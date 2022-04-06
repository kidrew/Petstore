import PetStore from 0xf8d6e0586b0a20c7

// This transaction transfers a token from one user's collection to another user's collection.
transaction(tokenId: UInt64, recipientAddr: Address) {

    // The field holds the NFT as it is being transferred to the other account.
    let token: @PetStore.NFT

    prepare(account: AuthAccount) {

        // Create a reference to borrowed 'NFTCollection' capability.
        // Note that because 'NFTCollection' is publicy defined in the contract, any account can access it.
        let collectionRef = account.borrow<&PetStore.NFTCollection>(from: /storage/NFTCollection)
            ?? panic("Could not borrow a reference to the owner's collection")
        
        // Call the withdraw function on the sender's Collection to move the NFT out of the collection.
        self.token <- collectionRef.withdraw(id: tokenId)
    }

    execute {
        // Get the recipient's public account object.
        let recipient = getAccount(recipientAddr)

        // This is familiar since we have done this before in the last 'MintToken' transaction block.
        let receiverRef = recipient.getCapability<&{PetStore.NFTReceiver}>(/public/NFTReceiver)
            .borrow()
            ?? panic("Could not borrow receiver reference")
        
        // Deposit the NFT in the receivers collection.
        receiverRef.deposit(token: <-self.token)

        // Save the new owner into 'owners' dictionary for look-ups.
        PetStore.owners[tokenId] = recipientAddr
    }
}