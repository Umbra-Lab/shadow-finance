/** 
This is a demo for testnet which allows faster transactions
by removing the overhead of importing, hashing, etc.
Therefore, this version is actually impractical for real use-cases
and will NOT be used as a part of the real product.
**/
program shadowfi_demo_v2_0.aleo {
/** Temporary ID to identify records **/
    const ID_ZEC: u8 = 1u8;
    const ID_SHFI: u8 = 2u8;
    const ID_ZECSHFI: u8 = 3u8;
/** Temporary ID to identify records **/

/** Utility functions **/
    inline math_min(n1: u64, n2: u64) -> u64 {
        return n1 < n2 ? n1 : n2;
    }

    function square_root(x: u64) -> u64 {
        let z: u64 = (x + 1u64) / 2u64;
        let y: u64 = x;

        for i: u8 in 0u8..42u8 {
            if (z >= y) {
                return y;
            }

            y = z;
            z = (x / z + z) / 2u64;
        }

        return 0u64;
    }
/** Utility functions **/

/** Z-Cash test token **/
    const MAX_MINT_AMOUNT_ZEC: u64 = 100_000u64;
    const SUPPLY_CAP_ZEC: u64 = 100_000_000_000u64;

    mapping supply_zec: bool => u64;
    mapping balances_zec: address => u64;

    record ZEC {
        owner: address,
        amount: u64,
        id: u8,
    }

    async transition mint_zec(owner: address, amount: u64) -> (ZEC, Future) {
        assert(amount <= MAX_MINT_AMOUNT_ZEC);

        return (ZEC {
            owner,
            amount,
            id: ID_ZEC,
        }, finalize_mint_zec(amount));
    }
    async function finalize_mint_zec(amount: u64) {
        let total_supply: u64 = Mapping::get_or_use(supply_zec, true, 0u64);
        let new_supply: u64 = total_supply + amount;

        assert(new_supply <= SUPPLY_CAP_ZEC);

        Mapping::set(supply_zec, true, new_supply);
    }

    transition transfer_zec(token: ZEC, receiver: address, amount: u64) -> (ZEC, ZEC) {
        let remaining: ZEC = ZEC {
            owner: token.owner,
            amount: token.amount - amount,
            id: ID_ZEC,
        };

        let transferred: ZEC = ZEC {
            owner: receiver,
            amount,
            id: ID_ZEC,
        };

        return (remaining, transferred);
    }

    async transition transfer_public_zec(receiver: address, amount: u64) -> Future {
        return finalize_transfer_public_zec(self.caller, receiver, amount);
    }
    async function finalize_transfer_public_zec(owner: address, receiver: address, amount: u64) {
        let owner_balance: u64 = Mapping::get(balances_zec, owner);
        Mapping::set(balances_zec, owner, owner_balance - amount);

        let receiver_balance: u64 = Mapping::get_or_use(balances_zec, owner, 0u64);
        Mapping::set(balances_zec, receiver, receiver_balance + amount);
    }

    async transition deposit_zec(token: ZEC, amount: u64) -> (ZEC, Future) {
        let remaining: ZEC = ZEC {
            owner: token.owner,
            amount: token.amount - amount,
            id: ID_ZEC,
        };

        return (remaining, finalize_deposit_zec(self.caller, amount));
    }
    async function finalize_deposit_zec(owner: address, amount: u64) {
        let balance: u64 = Mapping::get_or_use(balances_zec, owner, 0u64);
        Mapping::set(balances_zec, owner, balance + amount);
    }

    async transition withdraw_zec(receiver: address, amount: u64) -> (ZEC, Future) {
        let token: ZEC = ZEC {
            owner: receiver,
            amount,
            id: ID_ZEC,
        };

        return (token, finalize_withdraw_zec(self.caller, amount));
    }
    async function finalize_withdraw_zec(owner: address, amount: u64) {
        let balance: u64 = Mapping::get(balances_zec, owner);
        Mapping::set(balances_zec, owner, balance - amount);
    }
/** Z-Cash test token **/

/** Shadow Finance test token **/
    const MAX_MINT_AMOUNT_SHFI: u64 = 100_000u64;
    const SUPPLY_CAP_SHFI: u64 = 100_000_000_000u64;

    mapping supply_shfi: bool => u64;
    mapping balances_shfi: address => u64;

    record SHFI {
        owner: address,
        amount: u64,
        id: u8,
    }

    async transition mint_shfi(owner: address, amount: u64) -> (SHFI, Future) {
        assert(amount <= MAX_MINT_AMOUNT_SHFI);

        return (SHFI {
            owner,
            amount,
            id: ID_SHFI,
        }, finalize_mint_shfi(amount));
    }
    async function finalize_mint_shfi(amount: u64) {
        let total_supply: u64 = Mapping::get_or_use(supply_shfi, true, 0u64);
        let new_supply: u64 = total_supply + amount;

        assert(new_supply <= SUPPLY_CAP_SHFI);

        Mapping::set(supply_shfi, true, new_supply);
    }

    transition transfer_shfi(token: SHFI, receiver: address, amount: u64) -> (SHFI, SHFI) {
        let remaining: SHFI = SHFI {
            owner: token.owner,
            amount: token.amount - amount,
            id: ID_SHFI,
        };

        let transferred: SHFI = SHFI {
            owner: receiver,
            amount,
            id: ID_SHFI,
        };

        return (remaining, transferred);
    }

    async transition transfer_public_shfi(receiver: address, amount: u64) -> Future {
        return finalize_transfer_public_shfi(self.caller, receiver, amount);
    }
    async function finalize_transfer_public_shfi(owner: address, receiver: address, amount: u64) {
        let owner_balance: u64 = Mapping::get(balances_shfi, owner);
        Mapping::set(balances_shfi, owner, owner_balance - amount);

        let receiver_balance: u64 = Mapping::get_or_use(balances_shfi, owner, 0u64);
        Mapping::set(balances_shfi, receiver, receiver_balance + amount);
    }

    async transition deposit_shfi(token: SHFI, amount: u64) -> (SHFI, Future) {
        let remaining: SHFI = SHFI {
            owner: token.owner,
            amount: token.amount - amount,
            id: ID_SHFI,
        };

        return (remaining, finalize_deposit_shfi(self.caller, amount));
    }
    async function finalize_deposit_shfi(owner: address, amount: u64) {
        let balance: u64 = Mapping::get_or_use(balances_shfi, owner, 0u64);
        Mapping::set(balances_shfi, owner, balance + amount);
    }

    async transition withdraw_shfi(receiver: address, amount: u64) -> (SHFI, Future) {
        let token: SHFI = SHFI {
            owner: receiver,
            amount,
            id: ID_SHFI,
        };

        return (token, finalize_withdraw_shfi(self.caller, amount));
    }
    async function finalize_withdraw_shfi(owner: address, amount: u64) {
        let balance: u64 = Mapping::get(balances_shfi, owner);
        Mapping::set(balances_shfi, owner, balance - amount);
    }
/** Shadow Finance test token **/

/** Shadow Finance automated market maker suitable for volatile assets (ZEC & SHFI liquidity pool) **/
    mapping supply_zecshfi: bool => u64;
    mapping reserves_zecshfi: bool => u64;
    mapping balances_zecshfi: u64 => u64;

    record ZECSHFI {
        owner: address,
        claim: u64,
        id: u8,
    }

    async transition initialize_pool_zecshfi(owner: address, claim: u64, token0: ZEC, amount0: u64, token1: SHFI, amount1: u64) -> (ZEC, SHFI, ZECSHFI, Future) {
        let remaining0: ZEC = ZEC {
            owner,
            amount: token0.amount - amount0,
            id: ID_ZEC,
        };
        let remaining1: SHFI = SHFI {
            owner,
            amount: token1.amount - amount1,
            id: ID_SHFI,
        };

        let token: ZECSHFI = ZECSHFI {
            owner,
            claim,
            id: ID_ZECSHFI,
        };

        let initial_lp: u64 = square_root(amount0 * amount1) - 1000u64;

        return (remaining0, remaining1, token, finalize_initialize_pool_zecshfi(claim, amount0, amount1, initial_lp));
    }
    async function finalize_initialize_pool_zecshfi(owner: u64, token0: u64, token1: u64, initial_lp: u64) {
        assert(!Mapping::contains(supply_zecshfi, true));

        Mapping::set(reserves_zecshfi, false, token0);
        Mapping::set(reserves_zecshfi, true, token1);

        Mapping::set(supply_zecshfi, true, initial_lp);

        Mapping::set(balances_zecshfi, owner, initial_lp);
    }

    async transition init_lp_zecshfi(owner: address, claim: u64, token0: ZEC, amount0: u64, token1: SHFI, amount1: u64) -> (ZEC, SHFI, ZECSHFI, Future) {
        let remaining0: ZEC = ZEC {
            owner,
            amount: token0.amount - amount0,
            id: ID_ZEC,
        };
        let remaining1: SHFI = SHFI {
            owner,
            amount: token1.amount - amount1,
            id: ID_SHFI,
        };

        let token: ZECSHFI = ZECSHFI {
            owner,
            claim,
            id: ID_ZECSHFI,
        };

        return (remaining0, remaining1, token, finalize_init_lp_zecshfi(claim, amount0, amount1));
    }
    async function finalize_init_lp_zecshfi(owner: u64, token0: u64, token1: u64) {
        assert(!Mapping::contains(balances_zecshfi, owner));
        let total_supply: u64 = Mapping::get(supply_zecshfi, true);

        assert_neq(total_supply, 0u64);

        let reserve0: u64 = Mapping::get(reserves_zecshfi, false);
        let reserve1: u64 = Mapping::get(reserves_zecshfi, true);
        
        let lp0: u64 = (token0 * total_supply) / reserve0;
        let lp1: u64 = (token1 * total_supply) / reserve1;

        let lp: u64 = math_min(lp0, lp1);

        Mapping::set(reserves_zecshfi, false, reserve0 + token0);
        Mapping::set(reserves_zecshfi, true, reserve1 + token1);

        Mapping::set(supply_zecshfi, true, total_supply + lp);

        Mapping::set(balances_zecshfi, owner, lp);
    }

    async transition add_lp_zecshfi(owner: address, token: ZECSHFI, token0: ZEC, amount0: u64, token1: SHFI, amount1: u64) -> (ZEC, SHFI, ZECSHFI, Future) {
        let remaining0: ZEC = ZEC {
            owner,
            amount: token0.amount - amount0,
            id: ID_ZEC,
        };
        let remaining1: SHFI = SHFI {
            owner,
            amount: token1.amount - amount1,
            id: ID_SHFI,
        };
        let claim: u64 = token.claim;
        let re_token: ZECSHFI = ZECSHFI {
            owner,
            claim,
            id: ID_ZECSHFI,
        };

        return (remaining0, remaining1, re_token, finalize_add_lp_zecshfi(claim, amount0, amount1));
    }
    async function finalize_add_lp_zecshfi(owner: u64, token0: u64, token1: u64) {
        let total_supply: u64 = Mapping::get(supply_zecshfi, true);

        assert_neq(total_supply, 0u64);

        let reserve0: u64 = Mapping::get(reserves_zecshfi, false);
        let reserve1: u64 = Mapping::get(reserves_zecshfi, true);
        
        let lp0: u64 = (token0 * total_supply) / reserve0;
        let lp1: u64 = (token1 * total_supply) / reserve1;

        let lp: u64 = math_min(lp0, lp1);

        Mapping::set(reserves_zecshfi, false, reserve0 + token0);
        Mapping::set(reserves_zecshfi, true, reserve1 + token1);

        Mapping::set(supply_zecshfi, true, total_supply + lp);

        let current_lp: u64 = Mapping::get(balances_zecshfi, owner);
        Mapping::set(balances_zecshfi, owner, current_lp + lp);
    }

    async transition burn_lp_zecshfi(owner: address, token: ZECSHFI, amount0: u64, amount1: u64) -> (ZEC, SHFI, Future) {
        let token0: ZEC = ZEC {
            owner,
            amount: amount0,
            id: ID_ZEC,
        };
        let token1: SHFI = SHFI {
            owner,
            amount: amount1,
            id: ID_SHFI,
        };

        return (token0, token1, finalize_burn_lp_zecshfi(token.claim, amount0, amount1));
    }
    async function finalize_burn_lp_zecshfi(owner: u64, amount0: u64, amount1: u64) {
        let total_supply: u64 = Mapping::get(supply_zecshfi, true);

        let lp: u64 = Mapping::get(balances_zecshfi, owner);

        let reserve0: u64 = Mapping::get(reserves_zecshfi, false);
        let reserve1: u64 = Mapping::get(reserves_zecshfi, true);

        assert(amount0 <= (lp * reserve0) / total_supply);
        assert(amount1 <= (lp * reserve1) / total_supply);

        Mapping::set(reserves_zecshfi, false, reserve0 - amount0);
        Mapping::set(reserves_zecshfi, true, reserve1 - amount1);

        Mapping::set(supply_zecshfi, true, total_supply - lp);

        Mapping::remove(balances_zecshfi, owner);
    }

    async transition swap_to_0_zecshfi(owner: address, token1In: SHFI, amount1In: u64, amount0Out: u64) -> (ZEC, SHFI, Future) {
        let token0: ZEC = ZEC {
            owner,
            amount: amount0Out,
            id: ID_ZEC,
        };
        let token1: SHFI = SHFI {
            owner,
            amount: token1In.amount - amount1In,
            id: ID_SHFI,
        };

        return (token0, token1, finalize_swap_to_0_zecshfi(amount1In, amount0Out));
    }
    async function finalize_swap_to_0_zecshfi(amount1In: u64, amount0Out: u64) {
        let reserve0: u64 = Mapping::get(reserves_zecshfi, false);
        let reserve1: u64 = Mapping::get(reserves_zecshfi, true);

        let new_reserve0: u64 = reserve0 - amount0Out;
        let new_reserve1: u64 = reserve1 + amount1In;

        assert(new_reserve0 * new_reserve1 >= reserve0 * reserve1);

        Mapping::set(reserves_zecshfi, false, new_reserve0);
        Mapping::set(reserves_zecshfi, true, new_reserve1);
    }

    async transition swap_to_1_zecshfi(owner: address, token0In: ZEC, amount0In: u64, amount1Out: u64) -> (ZEC, SHFI, Future) {        
        let token0: ZEC = ZEC {
            owner,
            amount: token0In.amount - amount0In,
            id: ID_ZEC,
        };
        let token1: SHFI = SHFI {
            owner,
            amount: amount1Out,
            id: ID_SHFI,
        };

        return (token0, token1, finalize_swap_to_1_zecshfi(amount0In, amount1Out));
    }
    async function finalize_swap_to_1_zecshfi(amount0In: u64, amount1Out: u64) {
        let reserve0: u64 = Mapping::get(reserves_zecshfi, false);
        let reserve1: u64 = Mapping::get(reserves_zecshfi, true);

        let new_reserve0: u64 = reserve0 + amount0In;
        let new_reserve1: u64 = reserve1 - amount1Out;

        assert(new_reserve0 * new_reserve1 >= reserve0 * reserve1);

        Mapping::set(reserves_zecshfi, false, new_reserve0);
        Mapping::set(reserves_zecshfi, true, new_reserve1);
    }
/** Shadow Finance automated market maker suitable for volatile assets (ZEC & SHFI liquidity pool) **/
}
