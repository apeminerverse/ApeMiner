from scripts.functions import *

yart_airdrop_ipfs = 'https://nftstorage.link/ipfs/bafkreihmdyd4vwz2or5qdcibauvkunah6dvkabya7cj5maz5lixtbw44bm'
open_airdrop_ipfs = 'https://nftstorage.link/ipfs/bafkreier72vel7fvsonaalmvpm7pyiurbec45xy6oizmmyruyde6zaidie'
apeminer_ipfs = 'https://nftstorage.link/ipfs/bafkreiamehcsywzt3767uswrombs2qexunn2edlwxurzhduv4j27wdicma'


def main():
    active_network = network.show_active()
    print("Current Network:" + active_network)

    admin, creator, consumer, iwan = get_accounts(active_network)

    try:
        if active_network in LOCAL_NETWORKS:
            # nft = YachtPartyAirdrop.deploy(url, '', addr(admin))
            yarcht_party_nft = YachtPartyAirdrop.deploy(yart_airdrop_ipfs,
                                                        addr(admin))
            public_airdrop_nft = ApeMinerAirdrop.deploy("", open_airdrop_ipfs,
                                                        addr(admin))
            sale_nft = ApeMinerNFT.deploy("", apeminer_ipfs, 0.5*10**18,
                                          addr(admin))

            tx = sale_nft.startPublicSale(addr(admin))
            tx.wait(1)
            tx = public_airdrop_nft.startAirdrop(addr(admin))
            tx.wait(1)

            yarcht_party_nft.airdropMint(
                [iwan, creator, consumer, admin], addr(admin))
            public_airdrop_nft.airdropMint(addr(iwan))
            sale_nft.publicSaleMint(5, addr2(iwan, 5*10**18))

        if active_network in TEST_NETWORKS:
            yarcht_party_nft = YachtPartyAirdrop[-1]
            public_airdrop_nft = ApeMinerAirdrop[-1]
            sale_nft = ApeMinerNFT[-1]

            # tx = public_airdrop_nft.startAirdrop(addr(admin))
            # tx.wait(1)
            # tx = sale_nft.startPublicSale(addr(admin))
            # tx.wait(1)

            # yarcht_party_nft.airdropMint(
            #     [iwan, creator, consumer, admin], addr(admin))
            # public_airdrop_nft.airdropMint(addr(creator))
            # sale_nft.publicSaleMint(1, addr2(creator, 0.5*10**18))

        if active_network in REAL_NETWORKS:
            yarcht_party_airdrop = YachtPartyAirdrop[-1]
            apeminer_airdrop = ApeMinerAirdrop[-1]
            apuminer_mint = ApeMinerNFT[-1]

            tx = sale_nft.startPublicSale(addr(admin))
            tx.wait(1)
            tx = public_airdrop_nft.startAirdrop(addr(admin))
            tx.wait(1)

            yarcht_party_nft.airdropMint(
                [iwan, creator, consumer, admin], addr(admin))
            public_airdrop_nft.airdropMint(addr(iwan))
            sale_nft.publicSaleMint(5, addr2(iwan, 5*10**18))

    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
