import PetStore from 0xf8d6e0586b0a20c7

// All scripts start with the `main` function, which can take an arbitrary number of arguments an return any type of data.

// This function acceps a token ID and returns a metadata dictionary.
pub fun main(id: UInt64) : {String: String} {

    // Access the address that owns the NFT with the provided ID.s
    let ownerAddress = PetStore.owners[id]!

    // We encounter the 'getAccount(_ addr: Address)' function again.
    // Get the 'AuthAccount' instance of the current owner.
    let ownerAcct = getAccount(ownerAddress)

    // Borrow the 'NFTReceiver' capability of the owner.
    let receiverRef = ownerAcct.getCapability<&{PetStore.NFTReceiver}>(/public/NFTReceiver)
        .borrow()
        ?? panic("Could not borrow receiver reference")
    
    // Happily delegate this query to the owning collection to do the grunt work of getting its token's metadata.
    return receiverRef.getTokenMetadata(id: id)
}