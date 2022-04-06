import PetStore from 0xf8d6e0586b0a20c7

pub fun main() : [UInt64] {
    // We basically just return all the UInt64 keys of 'owners' dictionary as an array to get all IDs of all tokens in existence.
    return PetStore.owners.keys
}