#  --match-contract  MulticallerStackTest --match-test testBalanceStaticCallAndTransferNotAligned -vvvv

forge test --fork-url http://localhost:8545 \
  --sender 0x16Df4b25e4E37A9116eb224799c1e0Fb17fd8d30  \
  --match-contract MulticallerGasBench --match-test combo  -vvv
