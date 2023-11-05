program shadowfi_token_shadow_v1_0.aleo {
    const MAX_MINT_AMOUNT: u64 = 100_000u64;
    const SUPPLY_CAP: u64 = 100_000_000_000u64;

    mapping supply_shadow: u8 => u64;
    mapping balances_shadow: address => u64;

    record ShadowToken {
        owner: address,
        amount: u64,
    }

    transition mint_shadow(owner: address, amount: u64) -> ShadowToken {
        assert(amount <= MAX_MINT_AMOUNT);

        return ShadowToken {
            owner,
            amount,
        } then finalize(amount);
    }
    finalize mint_shadow(amount: u64) {
        let total_supply: u64 = Mapping::get_or_use(supply_shadow, 0u8, 0u64);
        let new_supply: u64 = total_supply + amount;

        assert(new_supply <= SUPPLY_CAP);

        Mapping::set(supply_shadow, 0u8, new_supply);
    }

    transition transfer_shadow(token: ShadowToken, receiver: address, amount: u64) -> (ShadowToken, ShadowToken) {
        let remaining: ShadowToken = ShadowToken {
            owner: token.owner,
            amount: token.amount - amount,
        };

        let transferred: ShadowToken = ShadowToken {
            owner: receiver,
            amount,
        };

        return (remaining, transferred);
    }

    transition transfer_public_shadow(receiver: address, amount: u64) {
        return then finalize(self.caller, receiver, amount);
    }
    finalize transfer_public_shadow(owner: address, receiver: address, amount: u64) {
        let owner_balance: u64 = Mapping::get(balances_shadow, owner);
        Mapping::set(balances_shadow, owner, owner_balance - amount);

        let receiver_balance: u64 = Mapping::get_or_use(balances_shadow, owner, 0u64);
        Mapping::set(balances_shadow, receiver, receiver_balance + amount);
    }

    transition deposit_shadow(token: ShadowToken, amount: u64) -> ShadowToken {
        let remaining: ShadowToken = ShadowToken {
            owner: token.owner,
            amount: token.amount - amount,
        };

        return remaining then finalize(self.caller, amount);
    }
    finalize deposit_shadow(owner: address, amount: u64) {
        let balance: u64 = Mapping::get_or_use(balances_shadow, owner, 0u64);
        Mapping::set(balances_shadow, owner, balance + amount);
    }

    transition withdraw_shadow(receiver: address, amount: u64) -> ShadowToken {
        let token: ShadowToken = ShadowToken {
            owner: receiver,
            amount,
        };

        return token then finalize(self.caller, amount);
    }
    finalize withdraw_shadow(owner: address, amount: u64) {
        let balance: u64 = Mapping::get(balances_shadow, owner);
        Mapping::set(balances_shadow, owner, balance - amount);
    }
}
