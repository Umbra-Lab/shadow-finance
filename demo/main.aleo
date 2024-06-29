program shadowfi_demo_v2_0.aleo;

record ZEC:
    owner as address.private;
    amount as u64.private;
    id as u8.private;

record SHFI:
    owner as address.private;
    amount as u64.private;
    id as u8.private;

record ZECSHFI:
    owner as address.private;
    claim as u64.private;
    id as u8.private;


mapping supply_zec:
	key as boolean.public;
	value as u64.public;


mapping balances_zec:
	key as address.public;
	value as u64.public;


mapping supply_shfi:
	key as boolean.public;
	value as u64.public;


mapping balances_shfi:
	key as address.public;
	value as u64.public;


mapping supply_zecshfi:
	key as boolean.public;
	value as u64.public;


mapping reserves_zecshfi:
	key as boolean.public;
	value as u64.public;


mapping balances_zecshfi:
	key as u64.public;
	value as u64.public;


function mint_zec:
    input r0 as address.private;
    input r1 as u64.private;
    lte r1 100_000u64 into r2;
    assert.eq r2 true;
    cast r0 r1 1u8 into r3 as ZEC.record;
    async mint_zec r1 into r4;
    output r3 as ZEC.record;
    output r4 as shadowfi_demo_v2_0.aleo/mint_zec.future;

finalize mint_zec:
    input r0 as u64.public;
    get.or_use supply_zec[true] 0u64 into r1;
    add r1 r0 into r2;
    lte r2 100_000_000_000u64 into r3;
    assert.eq r3 true;
    set r2 into supply_zec[true];



function transfer_zec:
    input r0 as ZEC.record;
    input r1 as address.private;
    input r2 as u64.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 1u8 into r4 as ZEC.record;
    cast r1 r2 1u8 into r5 as ZEC.record;
    output r4 as ZEC.record;
    output r5 as ZEC.record;



function transfer_public_zec:
    input r0 as address.private;
    input r1 as u64.private;
    async transfer_public_zec self.caller r0 r1 into r2;
    output r2 as shadowfi_demo_v2_0.aleo/transfer_public_zec.future;

finalize transfer_public_zec:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    get balances_zec[r0] into r3;
    sub r3 r2 into r4;
    set r4 into balances_zec[r0];
    get.or_use balances_zec[r0] 0u64 into r5;
    add r5 r2 into r6;
    set r6 into balances_zec[r1];




function deposit_zec:
    input r0 as ZEC.record;
    input r1 as u64.private;
    sub r0.amount r1 into r2;
    cast r0.owner r2 1u8 into r3 as ZEC.record;
    async deposit_zec self.caller r1 into r4;
    output r3 as ZEC.record;
    output r4 as shadowfi_demo_v2_0.aleo/deposit_zec.future;

finalize deposit_zec:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use balances_zec[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into balances_zec[r0];




function withdraw_zec:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 1u8 into r2 as ZEC.record;
    async withdraw_zec self.caller r1 into r3;
    output r2 as ZEC.record;
    output r3 as shadowfi_demo_v2_0.aleo/withdraw_zec.future;

finalize withdraw_zec:
    input r0 as address.public;
    input r1 as u64.public;
    get balances_zec[r0] into r2;
    sub r2 r1 into r3;
    set r3 into balances_zec[r0];




function mint_shfi:
    input r0 as address.private;
    input r1 as u64.private;
    lte r1 100_000u64 into r2;
    assert.eq r2 true;
    cast r0 r1 2u8 into r3 as SHFI.record;
    async mint_shfi r1 into r4;
    output r3 as SHFI.record;
    output r4 as shadowfi_demo_v2_0.aleo/mint_shfi.future;

finalize mint_shfi:
    input r0 as u64.public;
    get.or_use supply_shfi[true] 0u64 into r1;
    add r1 r0 into r2;
    lte r2 100_000_000_000u64 into r3;
    assert.eq r3 true;
    set r2 into supply_shfi[true];



function transfer_shfi:
    input r0 as SHFI.record;
    input r1 as address.private;
    input r2 as u64.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 2u8 into r4 as SHFI.record;
    cast r1 r2 2u8 into r5 as SHFI.record;
    output r4 as SHFI.record;
    output r5 as SHFI.record;



function transfer_public_shfi:
    input r0 as address.private;
    input r1 as u64.private;
    async transfer_public_shfi self.caller r0 r1 into r2;
    output r2 as shadowfi_demo_v2_0.aleo/transfer_public_shfi.future;

finalize transfer_public_shfi:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    get balances_shfi[r0] into r3;
    sub r3 r2 into r4;
    set r4 into balances_shfi[r0];
    get.or_use balances_shfi[r0] 0u64 into r5;
    add r5 r2 into r6;
    set r6 into balances_shfi[r1];




function deposit_shfi:
    input r0 as SHFI.record;
    input r1 as u64.private;
    sub r0.amount r1 into r2;
    cast r0.owner r2 2u8 into r3 as SHFI.record;
    async deposit_shfi self.caller r1 into r4;
    output r3 as SHFI.record;
    output r4 as shadowfi_demo_v2_0.aleo/deposit_shfi.future;

finalize deposit_shfi:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use balances_shfi[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into balances_shfi[r0];




function withdraw_shfi:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 2u8 into r2 as SHFI.record;
    async withdraw_shfi self.caller r1 into r3;
    output r2 as SHFI.record;
    output r3 as shadowfi_demo_v2_0.aleo/withdraw_shfi.future;

finalize withdraw_shfi:
    input r0 as address.public;
    input r1 as u64.public;
    get balances_shfi[r0] into r2;
    sub r2 r1 into r3;
    set r3 into balances_shfi[r0];



closure square_root:
    input r0 as u64;
    add r0 1u64 into r1;
    div r1 2u64 into r2;
    gte r2 r0 into r3;
    div r0 r2 into r4;
    add r4 r2 into r5;
    div r5 2u64 into r6;
    gte r6 r2 into r7;
    div r0 r6 into r8;
    add r8 r6 into r9;
    div r9 2u64 into r10;
    gte r10 r6 into r11;
    div r0 r10 into r12;
    add r12 r10 into r13;
    div r13 2u64 into r14;
    gte r14 r10 into r15;
    div r0 r14 into r16;
    add r16 r14 into r17;
    div r17 2u64 into r18;
    gte r18 r14 into r19;
    div r0 r18 into r20;
    add r20 r18 into r21;
    div r21 2u64 into r22;
    gte r22 r18 into r23;
    div r0 r22 into r24;
    add r24 r22 into r25;
    div r25 2u64 into r26;
    gte r26 r22 into r27;
    div r0 r26 into r28;
    add r28 r26 into r29;
    div r29 2u64 into r30;
    gte r30 r26 into r31;
    div r0 r30 into r32;
    add r32 r30 into r33;
    div r33 2u64 into r34;
    gte r34 r30 into r35;
    div r0 r34 into r36;
    add r36 r34 into r37;
    div r37 2u64 into r38;
    gte r38 r34 into r39;
    div r0 r38 into r40;
    add r40 r38 into r41;
    div r41 2u64 into r42;
    gte r42 r38 into r43;
    div r0 r42 into r44;
    add r44 r42 into r45;
    div r45 2u64 into r46;
    gte r46 r42 into r47;
    div r0 r46 into r48;
    add r48 r46 into r49;
    div r49 2u64 into r50;
    gte r50 r46 into r51;
    div r0 r50 into r52;
    add r52 r50 into r53;
    div r53 2u64 into r54;
    gte r54 r50 into r55;
    div r0 r54 into r56;
    add r56 r54 into r57;
    div r57 2u64 into r58;
    gte r58 r54 into r59;
    div r0 r58 into r60;
    add r60 r58 into r61;
    div r61 2u64 into r62;
    gte r62 r58 into r63;
    div r0 r62 into r64;
    add r64 r62 into r65;
    div r65 2u64 into r66;
    gte r66 r62 into r67;
    div r0 r66 into r68;
    add r68 r66 into r69;
    div r69 2u64 into r70;
    gte r70 r66 into r71;
    div r0 r70 into r72;
    add r72 r70 into r73;
    div r73 2u64 into r74;
    gte r74 r70 into r75;
    div r0 r74 into r76;
    add r76 r74 into r77;
    div r77 2u64 into r78;
    gte r78 r74 into r79;
    div r0 r78 into r80;
    add r80 r78 into r81;
    div r81 2u64 into r82;
    gte r82 r78 into r83;
    div r0 r82 into r84;
    add r84 r82 into r85;
    div r85 2u64 into r86;
    gte r86 r82 into r87;
    div r0 r86 into r88;
    add r88 r86 into r89;
    div r89 2u64 into r90;
    gte r90 r86 into r91;
    div r0 r90 into r92;
    add r92 r90 into r93;
    div r93 2u64 into r94;
    gte r94 r90 into r95;
    div r0 r94 into r96;
    add r96 r94 into r97;
    div r97 2u64 into r98;
    gte r98 r94 into r99;
    div r0 r98 into r100;
    add r100 r98 into r101;
    div r101 2u64 into r102;
    gte r102 r98 into r103;
    div r0 r102 into r104;
    add r104 r102 into r105;
    div r105 2u64 into r106;
    gte r106 r102 into r107;
    div r0 r106 into r108;
    add r108 r106 into r109;
    div r109 2u64 into r110;
    gte r110 r106 into r111;
    div r0 r110 into r112;
    add r112 r110 into r113;
    div r113 2u64 into r114;
    gte r114 r110 into r115;
    div r0 r114 into r116;
    add r116 r114 into r117;
    div r117 2u64 into r118;
    gte r118 r114 into r119;
    div r0 r118 into r120;
    add r120 r118 into r121;
    div r121 2u64 into r122;
    gte r122 r118 into r123;
    div r0 r122 into r124;
    add r124 r122 into r125;
    div r125 2u64 into r126;
    gte r126 r122 into r127;
    div r0 r126 into r128;
    add r128 r126 into r129;
    div r129 2u64 into r130;
    gte r130 r126 into r131;
    div r0 r130 into r132;
    add r132 r130 into r133;
    div r133 2u64 into r134;
    gte r134 r130 into r135;
    div r0 r134 into r136;
    add r136 r134 into r137;
    div r137 2u64 into r138;
    gte r138 r134 into r139;
    div r0 r138 into r140;
    add r140 r138 into r141;
    div r141 2u64 into r142;
    gte r142 r138 into r143;
    div r0 r142 into r144;
    add r144 r142 into r145;
    div r145 2u64 into r146;
    gte r146 r142 into r147;
    div r0 r146 into r148;
    add r148 r146 into r149;
    div r149 2u64 into r150;
    gte r150 r146 into r151;
    div r0 r150 into r152;
    add r152 r150 into r153;
    div r153 2u64 into r154;
    gte r154 r150 into r155;
    div r0 r154 into r156;
    add r156 r154 into r157;
    div r157 2u64 into r158;
    gte r158 r154 into r159;
    div r0 r158 into r160;
    add r160 r158 into r161;
    div r161 2u64 into r162;
    gte r162 r158 into r163;
    div r0 r162 into r164;
    add r164 r162 into r165;
    div r165 2u64 into r166;
    gte r166 r162 into r167;
    div r0 r166 into r168;
    add r168 r166 into r169;
    div r169 2u64 into r170;
    ternary r167 r162 0u64 into r171;
    ternary r163 r158 r171 into r172;
    ternary r159 r154 r172 into r173;
    ternary r155 r150 r173 into r174;
    ternary r151 r146 r174 into r175;
    ternary r147 r142 r175 into r176;
    ternary r143 r138 r176 into r177;
    ternary r139 r134 r177 into r178;
    ternary r135 r130 r178 into r179;
    ternary r131 r126 r179 into r180;
    ternary r127 r122 r180 into r181;
    ternary r123 r118 r181 into r182;
    ternary r119 r114 r182 into r183;
    ternary r115 r110 r183 into r184;
    ternary r111 r106 r184 into r185;
    ternary r107 r102 r185 into r186;
    ternary r103 r98 r186 into r187;
    ternary r99 r94 r187 into r188;
    ternary r95 r90 r188 into r189;
    ternary r91 r86 r189 into r190;
    ternary r87 r82 r190 into r191;
    ternary r83 r78 r191 into r192;
    ternary r79 r74 r192 into r193;
    ternary r75 r70 r193 into r194;
    ternary r71 r66 r194 into r195;
    ternary r67 r62 r195 into r196;
    ternary r63 r58 r196 into r197;
    ternary r59 r54 r197 into r198;
    ternary r55 r50 r198 into r199;
    ternary r51 r46 r199 into r200;
    ternary r47 r42 r200 into r201;
    ternary r43 r38 r201 into r202;
    ternary r39 r34 r202 into r203;
    ternary r35 r30 r203 into r204;
    ternary r31 r26 r204 into r205;
    ternary r27 r22 r205 into r206;
    ternary r23 r18 r206 into r207;
    ternary r19 r14 r207 into r208;
    ternary r15 r10 r208 into r209;
    ternary r11 r6 r209 into r210;
    ternary r7 r2 r210 into r211;
    ternary r3 r0 r211 into r212;
    output r212 as u64;



function initialize_pool_zecshfi:
    input r0 as address.private;
    input r1 as u64.private;
    input r2 as ZEC.record;
    input r3 as u64.private;
    input r4 as SHFI.record;
    input r5 as u64.private;
    sub r2.amount r3 into r6;
    cast r0 r6 1u8 into r7 as ZEC.record;
    sub r4.amount r5 into r8;
    cast r0 r8 2u8 into r9 as SHFI.record;
    cast r0 r1 3u8 into r10 as ZECSHFI.record;
    mul r3 r5 into r11;
    call square_root r11 into r12;
    sub r12 1000u64 into r13;
    async initialize_pool_zecshfi r1 r3 r5 r13 into r14;
    output r7 as ZEC.record;
    output r9 as SHFI.record;
    output r10 as ZECSHFI.record;
    output r14 as shadowfi_demo_v2_0.aleo/initialize_pool_zecshfi.future;

finalize initialize_pool_zecshfi:
    input r0 as u64.public;
    input r1 as u64.public;
    input r2 as u64.public;
    input r3 as u64.public;
    contains supply_zecshfi[true] into r4;
    not r4 into r5;
    assert.eq r5 true;
    set r1 into reserves_zecshfi[false];
    set r2 into reserves_zecshfi[true];
    set r3 into supply_zecshfi[true];
    set r3 into balances_zecshfi[r0];






function init_lp_zecshfi:
    input r0 as address.private;
    input r1 as u64.private;
    input r2 as ZEC.record;
    input r3 as u64.private;
    input r4 as SHFI.record;
    input r5 as u64.private;
    sub r2.amount r3 into r6;
    cast r0 r6 1u8 into r7 as ZEC.record;
    sub r4.amount r5 into r8;
    cast r0 r8 2u8 into r9 as SHFI.record;
    cast r0 r1 3u8 into r10 as ZECSHFI.record;
    async init_lp_zecshfi r1 r3 r5 into r11;
    output r7 as ZEC.record;
    output r9 as SHFI.record;
    output r10 as ZECSHFI.record;
    output r11 as shadowfi_demo_v2_0.aleo/init_lp_zecshfi.future;

finalize init_lp_zecshfi:
    input r0 as u64.public;
    input r1 as u64.public;
    input r2 as u64.public;
    contains balances_zecshfi[r0] into r3;
    not r3 into r4;
    assert.eq r4 true;
    get supply_zecshfi[true] into r5;
    assert.neq r5 0u64;
    get reserves_zecshfi[false] into r6;
    get reserves_zecshfi[true] into r7;
    mul r1 r5 into r8;
    div r8 r6 into r9;
    mul r2 r5 into r10;
    div r10 r7 into r11;
    lt r9 r11 into r12;
    ternary r12 r9 r11 into r13;
    add r6 r1 into r14;
    set r14 into reserves_zecshfi[false];
    add r7 r2 into r15;
    set r15 into reserves_zecshfi[true];
    add r5 r13 into r16;
    set r16 into supply_zecshfi[true];
    set r13 into balances_zecshfi[r0];




function add_lp_zecshfi:
    input r0 as address.private;
    input r1 as ZECSHFI.record;
    input r2 as ZEC.record;
    input r3 as u64.private;
    input r4 as SHFI.record;
    input r5 as u64.private;
    sub r2.amount r3 into r6;
    cast r0 r6 1u8 into r7 as ZEC.record;
    sub r4.amount r5 into r8;
    cast r0 r8 2u8 into r9 as SHFI.record;
    cast r0 r1.claim 3u8 into r10 as ZECSHFI.record;
    async add_lp_zecshfi r1.claim r3 r5 into r11;
    output r7 as ZEC.record;
    output r9 as SHFI.record;
    output r10 as ZECSHFI.record;
    output r11 as shadowfi_demo_v2_0.aleo/add_lp_zecshfi.future;

finalize add_lp_zecshfi:
    input r0 as u64.public;
    input r1 as u64.public;
    input r2 as u64.public;
    get supply_zecshfi[true] into r3;
    assert.neq r3 0u64;
    get reserves_zecshfi[false] into r4;
    get reserves_zecshfi[true] into r5;
    mul r1 r3 into r6;
    div r6 r4 into r7;
    mul r2 r3 into r8;
    div r8 r5 into r9;
    lt r7 r9 into r10;
    ternary r10 r7 r9 into r11;
    add r4 r1 into r12;
    set r12 into reserves_zecshfi[false];
    add r5 r2 into r13;
    set r13 into reserves_zecshfi[true];
    add r3 r11 into r14;
    set r14 into supply_zecshfi[true];
    get balances_zecshfi[r0] into r15;
    add r15 r11 into r16;
    set r16 into balances_zecshfi[r0];




function burn_lp_zecshfi:
    input r0 as address.private;
    input r1 as ZECSHFI.record;
    input r2 as u64.private;
    input r3 as u64.private;
    cast r0 r2 1u8 into r4 as ZEC.record;
    cast r0 r3 2u8 into r5 as SHFI.record;
    async burn_lp_zecshfi r1.claim r2 r3 into r6;
    output r4 as ZEC.record;
    output r5 as SHFI.record;
    output r6 as shadowfi_demo_v2_0.aleo/burn_lp_zecshfi.future;

finalize burn_lp_zecshfi:
    input r0 as u64.public;
    input r1 as u64.public;
    input r2 as u64.public;
    get supply_zecshfi[true] into r3;
    get balances_zecshfi[r0] into r4;
    get reserves_zecshfi[false] into r5;
    get reserves_zecshfi[true] into r6;
    mul r4 r5 into r7;
    div r7 r3 into r8;
    lte r1 r8 into r9;
    assert.eq r9 true;
    mul r4 r6 into r10;
    div r10 r3 into r11;
    lte r2 r11 into r12;
    assert.eq r12 true;
    sub r5 r1 into r13;
    set r13 into reserves_zecshfi[false];
    sub r6 r2 into r14;
    set r14 into reserves_zecshfi[true];
    sub r3 r4 into r15;
    set r15 into supply_zecshfi[true];
    remove balances_zecshfi[r0];




function swap_to_0_zecshfi:
    input r0 as address.private;
    input r1 as SHFI.record;
    input r2 as u64.private;
    input r3 as u64.private;
    cast r0 r3 1u8 into r4 as ZEC.record;
    sub r1.amount r2 into r5;
    cast r0 r5 2u8 into r6 as SHFI.record;
    async swap_to_0_zecshfi r2 r3 into r7;
    output r4 as ZEC.record;
    output r6 as SHFI.record;
    output r7 as shadowfi_demo_v2_0.aleo/swap_to_0_zecshfi.future;

finalize swap_to_0_zecshfi:
    input r0 as u64.public;
    input r1 as u64.public;
    get reserves_zecshfi[false] into r2;
    get reserves_zecshfi[true] into r3;
    sub r2 r1 into r4;
    add r3 r0 into r5;
    mul r4 r5 into r6;
    mul r2 r3 into r7;
    gte r6 r7 into r8;
    assert.eq r8 true;
    set r4 into reserves_zecshfi[false];
    set r5 into reserves_zecshfi[true];




function swap_to_1_zecshfi:
    input r0 as address.private;
    input r1 as ZEC.record;
    input r2 as u64.private;
    input r3 as u64.private;
    sub r1.amount r2 into r4;
    cast r0 r4 1u8 into r5 as ZEC.record;
    cast r0 r3 2u8 into r6 as SHFI.record;
    async swap_to_1_zecshfi r2 r3 into r7;
    output r5 as ZEC.record;
    output r6 as SHFI.record;
    output r7 as shadowfi_demo_v2_0.aleo/swap_to_1_zecshfi.future;

finalize swap_to_1_zecshfi:
    input r0 as u64.public;
    input r1 as u64.public;
    get reserves_zecshfi[false] into r2;
    get reserves_zecshfi[true] into r3;
    add r2 r0 into r4;
    sub r3 r1 into r5;
    mul r4 r5 into r6;
    mul r2 r3 into r7;
    gte r6 r7 into r8;
    assert.eq r8 true;
    set r4 into reserves_zecshfi[false];
    set r5 into reserves_zecshfi[true];

