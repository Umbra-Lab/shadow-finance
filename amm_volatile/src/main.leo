import shadowfi_token_zec_v1_1.leo;
import shadowfi_token_shfi_v1_1.leo;

program shadowfi_vamm_zecshfi_v1_4.aleo {    
    mapping supply_zecshfi: bool => u64;
    mapping reserves_zecshfi: bool => u64;
    mapping balances_zecshfi: u64 => u64;

    record ZECSHFI {
        owner: address,
        claim: u64,
    }

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

    transition initialize_pool_zecshfi(owner: address, claim: u64, token0: shadowfi_token_zec_v1_1.leo/ZEC, amount0: u64, token1: shadowfi_token_shfi_v1_1.leo/SHFI, amount1: u64) -> (shadowfi_token_zec_v1_1.leo/ZEC, shadowfi_token_shfi_v1_1.leo/SHFI, ZECSHFI) {
        let remaining0: ZEC = shadowfi_token_zec_v1_1.leo/deposit_zec(token0, amount0);
        let remaining1: SHFI = shadowfi_token_shfi_v1_1.leo/deposit_shfi(token1, amount1);

        let token: ZECSHFI = ZECSHFI {
            owner,
            claim,
        };

        let initial_lp: u64 = square_root(amount0 * amount1) - 1000u64;

        return (remaining0, remaining1, token) then finalize(claim, amount0, amount1, initial_lp);
    }
    finalize initialize_pool_zecshfi(owner: u64, token0: u64, token1: u64, initial_lp: u64) {
        assert(!Mapping::contains(supply_zecshfi, true));

        Mapping::set(reserves_zecshfi, false, token0);
        Mapping::set(reserves_zecshfi, true, token1);

        Mapping::set(supply_zecshfi, true, initial_lp);

        Mapping::set(balances_zecshfi, owner, initial_lp);
    }

    transition init_lp_zecshfi(owner: address, claim: u64, token0: shadowfi_token_zec_v1_1.leo/ZEC, amount0: u64, token1: shadowfi_token_shfi_v1_1.leo/SHFI, amount1: u64) -> (shadowfi_token_zec_v1_1.leo/ZEC, shadowfi_token_shfi_v1_1.leo/SHFI, ZECSHFI) {
        let remaining0: ZEC = shadowfi_token_zec_v1_1.leo/deposit_zec(token0, amount0);
        let remaining1: SHFI = shadowfi_token_shfi_v1_1.leo/deposit_shfi(token1, amount1);

        let token: ZECSHFI = ZECSHFI {
            owner,
            claim,
        };

        return (remaining0, remaining1, token) then finalize(claim, amount0, amount1);
    }
    finalize init_lp_zecshfi(owner: u64, token0: u64, token1: u64) {
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

    transition add_lp_zecshfi(token: ZECSHFI, token0: shadowfi_token_zec_v1_1.leo/ZEC, amount0: u64, token1: shadowfi_token_shfi_v1_1.leo/SHFI, amount1: u64) -> (shadowfi_token_zec_v1_1.leo/ZEC, shadowfi_token_shfi_v1_1.leo/SHFI, ZECSHFI) {
        let remaining0: ZEC = shadowfi_token_zec_v1_1.leo/deposit_zec(token0, amount0);
        let remaining1: SHFI = shadowfi_token_shfi_v1_1.leo/deposit_shfi(token1, amount1);

        let claim: u64 = token.claim;
        let re_token: ZECSHFI = ZECSHFI {
            owner: token.owner,
            claim,
        };

        return (remaining0, remaining1, re_token) then finalize(claim, amount0, amount1);
    }
    finalize add_lp_zecshfi(owner: u64, token0: u64, token1: u64) {
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

    transition burn_lp_zecshfi(receiver: address, token: ZECSHFI, amount0: u64, amount1: u64) -> (shadowfi_token_zec_v1_1.leo/ZEC, shadowfi_token_shfi_v1_1.leo/SHFI) {
        let token0: ZEC = shadowfi_token_zec_v1_1.leo/withdraw_zec(receiver, amount0);
        let token1: SHFI = shadowfi_token_shfi_v1_1.leo/withdraw_shfi(receiver, amount1);

        return (token0, token1) then finalize(token.claim, amount0, amount1);
    }
    finalize burn_lp_zecshfi(owner: u64, amount0: u64, amount1: u64) {
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

    transition swap_to_0_zecshfi(receiver: address, token1In: shadowfi_token_shfi_v1_1.leo/SHFI, amount1In: u64, amount0Out: u64) -> (shadowfi_token_zec_v1_1.leo/ZEC, shadowfi_token_shfi_v1_1.leo/SHFI) {
        let token0: ZEC = shadowfi_token_zec_v1_1.leo/withdraw_zec(receiver, amount0Out);
        let token1: SHFI = shadowfi_token_shfi_v1_1.leo/deposit_shfi(token1In, amount1In);

        return (token0, token1) then finalize(amount1In, amount0Out);
    }
    finalize swap_to_0_zecshfi(amount1In: u64, amount0Out: u64) {
        let reserve0: u64 = Mapping::get(reserves_zecshfi, false);
        let reserve1: u64 = Mapping::get(reserves_zecshfi, true);

        let new_reserve0: u64 = reserve0 - amount0Out;
        let new_reserve1: u64 = reserve1 + amount1In;

        assert(new_reserve0 * new_reserve1 >= reserve0 * reserve1);

        Mapping::set(reserves_zecshfi, false, new_reserve0);
        Mapping::set(reserves_zecshfi, true, new_reserve1);
    }

    transition swap_to_1_zecshfi(receiver: address, token0In: shadowfi_token_zec_v1_1.leo/ZEC, amount0In: u64, amount1Out: u64) -> (shadowfi_token_zec_v1_1.leo/ZEC, shadowfi_token_shfi_v1_1.leo/SHFI) {        
        let token0: ZEC = shadowfi_token_zec_v1_1.leo/deposit_zec(token0In, amount0In);
        let token1: SHFI = shadowfi_token_shfi_v1_1.leo/withdraw_shfi(receiver, amount1Out);

        return (token0, token1) then finalize(amount0In, amount1Out);
    }
    finalize swap_to_1_zecshfi(amount0In: u64, amount1Out: u64) {
        let reserve0: u64 = Mapping::get(reserves_zecshfi, false);
        let reserve1: u64 = Mapping::get(reserves_zecshfi, true);

        let new_reserve0: u64 = reserve0 + amount0In;
        let new_reserve1: u64 = reserve1 - amount1Out;

        assert(new_reserve0 * new_reserve1 >= reserve0 * reserve1);

        Mapping::set(reserves_zecshfi, false, new_reserve0);
        Mapping::set(reserves_zecshfi, true, new_reserve1);
    }
}
