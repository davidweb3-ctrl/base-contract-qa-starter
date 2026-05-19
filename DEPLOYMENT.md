# Base Sepolia Deployment Notes

Status: prepared, not deployed

## No-Money Rule

Do not deploy until the user explicitly decides to spend testnet/mainnet gas.

This file is for preparation and dry-runs.

## Environment

Required:

```bash
export PRIVATE_KEY=...
export BASE_SEPOLIA_RPC_URL=...
```

Optional:

```bash
export VAULT_OWNER=0x...
export ESCROW_SIGNER=0x...
```

If `VAULT_OWNER` or `ESCROW_SIGNER` are omitted, the deployer is used.

## Dry Run

Compile and simulate locally:

```bash
forge script script/DeployBaseSepolia.s.sol:DeployBaseSepolia
```

If `PRIVATE_KEY` is not set, the script should compile and then stop before deployment preparation. That is expected while using the no-money rule.

## Base Sepolia Simulation

Simulate against Base Sepolia RPC without broadcasting:

```bash
forge script script/DeployBaseSepolia.s.sol:DeployBaseSepolia \
  --rpc-url "$BASE_SEPOLIA_RPC_URL"
```

## Broadcast

Only after explicit approval:

```bash
forge script script/DeployBaseSepolia.s.sol:DeployBaseSepolia \
  --rpc-url "$BASE_SEPOLIA_RPC_URL" \
  --broadcast
```

## Verification Checklist

Before broadcast:

- [ ] `forge test -vv` passes.
- [ ] `PRIVATE_KEY` is a throwaway deployment key.
- [ ] The deployer wallet has only small testnet ETH.
- [ ] `VAULT_OWNER` is correct.
- [ ] `ESCROW_SIGNER` is correct.
- [ ] No production funds are involved.

After broadcast:

- [ ] Record contract addresses.
- [ ] Add deployment tx hashes.
- [ ] Update public proof file.
- [ ] Publish only as a testnet / public-proof artifact.
