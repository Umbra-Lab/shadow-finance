program shadowfi_token_shfi_v1_1.aleo {
    const MAX_MINT_AMOUNT_SHFI: u64 = 100_000u64;
    const SUPPLY_CAP_SHFI: u64 = 100_000_000_000u64;

    mapping supply_shfi: bool => u64;
    mapping balances_shfi: address => u64;

    record SHFI {
        owner: address,
        amount: u64,
    }

    transition mint_shfi(owner: address, amount: u64) -> SHFI {
        assert(amount <= MAX_MINT_AMOUNT_SHFI);

        return SHFI {
            owner,
            amount,
        } then finalize(amount);
    }
    finalize mint_shfi(amount: u64) {
        let total_supply: u64 = Mapping::get_or_use(supply_shfi, true, 0u64);
        let new_supply: u64 = total_supply + amount;

        assert(new_supply <= SUPPLY_CAP_SHFI);

        Mapping::set(supply_shfi, true, new_supply);
    }

    transition transfer_shfi(token: SHFI, receiver: address, amount: u64) -> (SHFI, SHFI) {
        let remaining: SHFI = SHFI {
            owner: token.owner,
            amount: token.amount - amount,
        };

        let transferred: SHFI = SHFI {
            owner: receiver,
            amount,
        };

        return (remaining, transferred);
    }

    transition transfer_public_shfi(receiver: address, amount: u64) {
        return then finalize(self.caller, receiver, amount);
    }
    finalize transfer_public_shfi(owner: address, receiver: address, amount: u64) {
        let owner_balance: u64 = Mapping::get(balances_shfi, owner);
        Mapping::set(balances_shfi, owner, owner_balance - amount);

        let receiver_balance: u64 = Mapping::get_or_use(balances_shfi, owner, 0u64);
        Mapping::set(balances_shfi, receiver, receiver_balance + amount);
    }

    transition deposit_shfi(token: SHFI, amount: u64) -> SHFI {
        let remaining: SHFI = SHFI {
            owner: token.owner,
            amount: token.amount - amount,
        };

        return remaining then finalize(self.caller, amount);
    }
    finalize deposit_shfi(owner: address, amount: u64) {
        let balance: u64 = Mapping::get_or_use(balances_shfi, owner, 0u64);
        Mapping::set(balances_shfi, owner, balance + amount);
    }

    transition withdraw_shfi(receiver: address, amount: u64) -> SHFI {
        let token: SHFI = SHFI {
            owner: receiver,
            amount,
        };

        return token then finalize(self.caller, amount);
    }
    finalize withdraw_shfi(owner: address, amount: u64) {
        let balance: u64 = Mapping::get(balances_shfi, owner);
        Mapping::set(balances_shfi, owner, balance - amount);
    }
}
