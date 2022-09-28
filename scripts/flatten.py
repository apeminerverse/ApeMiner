from scripts.functions import *

yart_airdrop_ipfs = 'https://nftstorage.link/ipfs/bafkreihmdyd4vwz2or5qdcibauvkunah6dvkabya7cj5maz5lixtbw44bm'
open_airdrop_ipfs = 'https://nftstorage.link/ipfs/bafkreier72vel7fvsonaalmvpm7pyiurbec45xy6oizmmyruyde6zaidie'
apeminer_ipfs = 'https://nftstorage.link/ipfs/bafkreiamehcsywzt3767uswrombs2qexunn2edlwxurzhduv4j27wdicma'


def main():
    active_network = network.show_active()
    print("Current Network:" + active_network)

    admin, creator, consumer, iwan = get_accounts(active_network)

    try:
        yarcht_party_airdrop = YachtPartyAirdrop.deploy(yart_airdrop_ipfs,
                                                        addr(admin))
        apeminer_airdrop = ApeMinerAirdrop.deploy("", open_airdrop_ipfs,
                                                  addr(admin))
        sale_nft = ApeMinerNFT.deploy("", apeminer_ipfs,   0.5*10**18,
                                      addr(admin))
        flat_contract('YachtPartyAirdrop',
                      YachtPartyAirdrop.get_verification_info())
        flat_contract('ApeMinerAirdrop',
                      ApeMinerAirdrop.get_verification_info())
        flat_contract('ApeMinerNFT',
                      ApeMinerNFT.get_verification_info())

    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
