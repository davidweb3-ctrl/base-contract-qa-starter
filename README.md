# Base Contract QA Starter

Version: v0.1

Status: local Foundry demo, not deployed

## Purpose

Small Base-oriented contract QA starter for builders who need testable examples around:

- owner-only controls;
- pause safety;
- signature authorization;
- nonce replay protection;
- deadline expiration;
- clear Foundry test evidence.

This is the first execution artifact for the Base Ship-And-Document path.

## Who This Is For

This is for Base builders who want a small, inspectable Foundry example for common contract QA patterns before shipping a larger app.

It is intentionally tiny:

- no external dependencies;
- no deployment required;
- no production claims;
- focused on clear tests.

## Why This Exists

The funding research suggests Base rewards shipped, documented, visible work. The personal fit analysis suggests a strong match around EVM/Foundry, testing, integration, and security/QA workflows.

This demo turns that fit into a public-proof candidate.

## Sponsor-Visible Value

This starter is designed to show a narrow but useful builder capability:

- identify common contract-risk areas;
- turn risk areas into executable Foundry tests;
- document what is covered and what is not covered;
- keep boundaries clear before deployment or grant claims;
- produce proof that can be reused in bounty, grant, or freelance conversations.

It is not trying to be a full audit framework. The useful proof is that a builder can quickly create inspectable QA scaffolding around a contract workflow.

## Contracts

- `src/OwnableVault.sol`: small ETH vault with owner-only withdraw and pause controls.
- `src/SignatureEscrow.sol`: signature-gated claim flow with per-recipient nonce and deadline checks.

## What To Inspect

For `OwnableVault`:

- `deposit` accepts ETH only when unpaused.
- `setPaused` is owner-only.
- `withdraw` is owner-only.

For `SignatureEscrow`:

- `claimDigest` binds the claim to chain id and contract address.
- `claim` checks recipient, deadline, nonce, and signer.
- nonce increments after successful claim.
- replay with the same signature fails.

## Tests

- `test/OwnableVault.t.sol`
- `test/SignatureEscrow.t.sol`

The tests avoid external dependencies and use only Foundry cheatcodes declared locally in the test files.

## Public Proof Page

Free static proof-page source is available in:

```text
docs/index.html
```

This page is intended for GitHub Pages or Talent/Base website verification if a public project URL is needed. It does not require paid hosting, a domain, or a mainnet deployment.

## Run

```bash
forge test -vv
```

Expected result:

```text
6 tests passed, 0 failed, 0 skipped
```

## Checklist

Use:

```text
CHECKLIST.md
```

The checklist covers:

- access control;
- pause safety;
- signature authorization;
- replay protection;
- deadline expiration;
- Base-specific public proof boundaries.

## Deployment Preparation

Base Sepolia deployment notes are prepared in:

```text
DEPLOYMENT.md
```

Deployment is not required for the current proof. Do not broadcast transactions unless the user explicitly decides to spend testnet gas.

## Current Boundary

This is not a production contract package, audit report, grant recipient, or deployed Base product.

It is a starter artifact for:

- public proof;
- Base builder documentation;
- future Base Builder Rewards / Builder Grants consideration;
- later expansion into a Base contract QA template library.

## Next Steps

- Keep local verification green with `forge test -vv`.
- Publish / maintain the free proof page if Talent/Base website verification needs a project URL.
- Use this as a proof asset when applying to technical bounties or Base-oriented opportunities.
- Add one more focused checklist module only if it supports a concrete opportunity.
- Run Base Sepolia deployment dry-run only if a public proof or reward path requires it.
