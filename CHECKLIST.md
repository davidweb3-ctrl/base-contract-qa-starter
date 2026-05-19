# Base Contract QA Checklist

Status: starter checklist

Use this checklist before treating a Base contract demo as public proof.

## Access Control

- [ ] Owner-only functions have tests for authorized caller.
- [ ] Owner-only functions have tests for unauthorized caller.
- [ ] Constructor rejects zero owner or invalid authority.
- [ ] Ownership / admin authority is clearly documented.

Covered in this starter:

- `OwnableVault.withdraw`
- `OwnableVault.setPaused`

## Pause Safety

- [ ] Paused state blocks risky user actions.
- [ ] Pause can only be toggled by authorized account.
- [ ] Tests cover both paused and unpaused paths.

Covered in this starter:

- `OwnableVault.deposit`

## Signature Authorization

- [ ] Signature digest includes chain id.
- [ ] Signature digest includes contract address.
- [ ] Signature digest includes recipient.
- [ ] Signature digest includes amount or action value.
- [ ] Signature digest includes nonce.
- [ ] Signature digest includes deadline.
- [ ] Invalid signer is rejected.

Covered in this starter:

- `SignatureEscrow.claimDigest`
- `SignatureEscrow.claim`

## Replay Protection

- [ ] Every claim or signed action has a nonce.
- [ ] Nonce changes after successful use.
- [ ] Reusing the same signature fails.
- [ ] Tests prove replay fails.

Covered in this starter:

- `SignatureEscrow.nonces`

## Deadline / Expiration

- [ ] Signed actions expire.
- [ ] Expired signatures fail.
- [ ] Boundary behavior is clear.

Covered in this starter:

- `SignatureEscrow.claim`

## Base-Specific Public Proof

- [ ] Tests pass locally.
- [ ] Deployment plan is documented.
- [ ] Base Sepolia deployment is optional and explicitly marked testnet.
- [ ] No production funds are used.
- [ ] README states boundaries and non-goals.

## Not Covered Yet

Future checklist modules:

- upgradeability safety;
- ERC20 approval risks;
- ERC721 marketplace settlement;
- vesting cliffs and schedules;
- permit / EIP-712 typed signatures;
- reentrancy;
- withdrawal queues;
- oracle / price-feed assumptions.
