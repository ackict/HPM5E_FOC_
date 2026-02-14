
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

80003000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
80003000:	800041b7          	lui	gp,0x80004
        addi    gp, gp, %lo(__global_pointer$)
80003004:	13418193          	addi	gp,gp,308 # 80004134 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
80003008:	01200237          	lui	tp,0x1200
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	06020213          	addi	tp,tp,96 # 1200060 <__SEGGER_RTL_locale_ptr>
        .option pop

        csrw    mstatus, zero
80003010:	30001073          	csrw	mstatus,zero
        csrw    mcause, zero
80003014:	34201073          	csrw	mcause,zero

    /* Initialize FCSR */
    fscsr zero
#endif

        lui     t0,     %hi(__stack_end__)
80003018:	002202b7          	lui	t0,0x220
        addi    sp, t0, %lo(__stack_end__)
8000301c:	00028113          	mv	sp,t0

#ifdef CONFIG_NOT_ENABLE_ICACHE
        call    l1c_ic_disable
#else
        call    l1c_ic_enable
80003020:	47d020ef          	jal	80005c9c <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003024:	445020ef          	jal	80005c68 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
80003028:	08d050ef          	jal	800088b4 <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
8000302c:	5d2050ef          	jal	800085fe <_init>

80003030 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003030:	8000b437          	lui	s0,0x8000b
80003034:	31840413          	addi	s0,s0,792 # 8000b318 <__SEGGER_RTL_ascii_ctype_map+0x80>

80003038 <.L_start_RunInit>:
L(RunInit):
        lw      a0, (s0)                        // Get next initialization function from table
80003038:	4008                	lw	a0,0(s0)
        add     s0, s0, 4                       // Increment table pointer to point to function arguments
8000303a:	0411                	addi	s0,s0,4
        jalr    a0                              // Call initialization function
8000303c:	9502                	jalr	a0
        j       L(RunInit)
8000303e:	bfed                	j	80003038 <.L_start_RunInit>

80003040 <__SEGGER_init_done>:
        // Time to call main(), the application entry point.
        //

#ifndef NO_CLEANUP_AT_START
    /* clean up */
    call _clean_up
80003040:	4de020ef          	jal	8000551e <_clean_up>

80003044 <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
80003044:	000002b7          	lui	t0,0x0
80003048:	00028293          	mv	t0,t0
    csrw mtvec, t0
8000304c:	30529073          	csrw	mtvec,t0
#if defined (USE_S_MODE_IRQ)
    la t0, __vector_s_table
    csrw stvec, t0
#endif
    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
80003050:	7d016073          	csrsi	0x7d0,2

80003054 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
80003054:	594050ef          	jal	800085e8 <reset_handler>
        tail    exit
80003058:	a009                	j	8000305a <exit>

8000305a <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
8000305a:	a001                	j	8000305a <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
8000305c:	4501                	li	a0,0
        li      a1, 0
8000305e:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
80003060:	588050ef          	jal	800085e8 <reset_handler>
        tail    exit
80003064:	bfdd                	j	8000305a <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>:
80003066:	8082                	ret

Disassembly of section .text.core_local_mem_to_sys_address:

80003f06 <core_local_mem_to_sys_address>:
#define HPM_CORE0 (0U)
#define HPM_CORE1 (1U)

/* map core local memory(DLM/ILM) to system address */
static inline uint32_t core_local_mem_to_sys_address(uint8_t core_id, uint32_t addr)
{
80003f06:	1141                	addi	sp,sp,-16
80003f08:	87aa                	mv	a5,a0
80003f0a:	c42e                	sw	a1,8(sp)
80003f0c:	00f107a3          	sb	a5,15(sp)
    (void) core_id;
    return addr;
80003f10:	47a2                	lw	a5,8(sp)
}
80003f12:	853e                	mv	a0,a5
80003f14:	0141                	addi	sp,sp,16
80003f16:	8082                	ret

Disassembly of section .text.trgm_output_config:

800043d4 <trgm_output_config>:
 * @param[in] ptr TRGM base address
 * @param[in] output Target output
 * @param[in] config Pointer to output configuration
 */
static inline void trgm_output_config(TRGM_Type *ptr, uint8_t output, trgm_output_t *config)
{
800043d4:	1141                	addi	sp,sp,-16
800043d6:	c62a                	sw	a0,12(sp)
800043d8:	87ae                	mv	a5,a1
800043da:	c232                	sw	a2,4(sp)
800043dc:	00f105a3          	sb	a5,11(sp)
    ptr->TRGOCFG[output] = TRGM_TRGOCFG_TRIGOSEL_SET(config->input)
800043e0:	4792                	lw	a5,4(sp)
800043e2:	0087c783          	lbu	a5,8(a5)
800043e6:	86be                	mv	a3,a5
                        | (config->type & TRGM_TRGOCFG_FEDG2PEN_MASK)
800043e8:	4792                	lw	a5,4(sp)
800043ea:	43d8                	lw	a4,4(a5)
800043ec:	000207b7          	lui	a5,0x20
800043f0:	8ff9                	and	a5,a5,a4
800043f2:	00f6e733          	or	a4,a3,a5
                        | (config->type & TRGM_TRGOCFG_REDG2PEN_MASK)
800043f6:	4792                	lw	a5,4(sp)
800043f8:	43d4                	lw	a3,4(a5)
800043fa:	67c1                	lui	a5,0x10
800043fc:	8ff5                	and	a5,a5,a3
800043fe:	00f766b3          	or	a3,a4,a5
                        | TRGM_TRGOCFG_OUTINV_SET(config->invert);
80004402:	4792                	lw	a5,4(sp)
80004404:	0007c783          	lbu	a5,0(a5) # 10000 <__NONCACHEABLE_RAM_segment_size__>
80004408:	01279713          	slli	a4,a5,0x12
8000440c:	000407b7          	lui	a5,0x40
80004410:	8f7d                	and	a4,a4,a5
    ptr->TRGOCFG[output] = TRGM_TRGOCFG_TRIGOSEL_SET(config->input)
80004412:	00b14783          	lbu	a5,11(sp)
                        | TRGM_TRGOCFG_OUTINV_SET(config->invert);
80004416:	8f55                	or	a4,a4,a3
    ptr->TRGOCFG[output] = TRGM_TRGOCFG_TRIGOSEL_SET(config->input)
80004418:	46b2                	lw	a3,12(sp)
8000441a:	40078793          	addi	a5,a5,1024 # 40400 <__AXI_SRAM_segment_size__+0x10400>
8000441e:	078a                	slli	a5,a5,0x2
80004420:	97b6                	add	a5,a5,a3
80004422:	c398                	sw	a4,0(a5)
}
80004424:	0001                	nop
80004426:	0141                	addi	sp,sp,16
80004428:	8082                	ret

Disassembly of section .text.pwmv2_shadow_register_unlock:

8000442a <pwmv2_shadow_register_unlock>:
 * @brief unlock all shadow register
 *
 * @param[in] pwm_x PWM base address, HPM_PWMx(x=0..n)
 */
static inline void pwmv2_shadow_register_unlock(PWMV2_Type *pwm_x)
{
8000442a:	1141                	addi	sp,sp,-16
8000442c:	c62a                	sw	a0,12(sp)
    pwm_x->WORK_CTRL0 = PWM_UNLOCK_KEY;
8000442e:	47b2                	lw	a5,12(sp)
80004430:	b0382737          	lui	a4,0xb0382
80004434:	60770713          	addi	a4,a4,1543 # b0382607 <__FLASH_segment_end__+0x30282607>
80004438:	c398                	sw	a4,0(a5)
}
8000443a:	0001                	nop
8000443c:	0141                	addi	sp,sp,16
8000443e:	8082                	ret

Disassembly of section .text.pwmv2_channel_enable_output:

80004440 <pwmv2_channel_enable_output>:
 *
 * @param pwm_x PWM base address, HPM_PWMx(x=0..n)
 * @param chn @ref pwm_channel_t
 */
static inline void pwmv2_channel_enable_output(PWMV2_Type *pwm_x, pwm_channel_t chn)
{
80004440:	1141                	addi	sp,sp,-16
80004442:	c62a                	sw	a0,12(sp)
80004444:	87ae                	mv	a5,a1
80004446:	00f105a3          	sb	a5,11(sp)
    pwm_x->PWM[chn].CFG1 |= PWMV2_PWM_CFG1_HIGHZ_EN_N_MASK;
8000444a:	00b14783          	lbu	a5,11(sp)
8000444e:	4732                	lw	a4,12(sp)
80004450:	07c1                	addi	a5,a5,16
80004452:	0792                	slli	a5,a5,0x4
80004454:	97ba                	add	a5,a5,a4
80004456:	43d4                	lw	a3,4(a5)
80004458:	00b14783          	lbu	a5,11(sp)
8000445c:	10000737          	lui	a4,0x10000
80004460:	8f55                	or	a4,a4,a3
80004462:	46b2                	lw	a3,12(sp)
80004464:	07c1                	addi	a5,a5,16
80004466:	0792                	slli	a5,a5,0x4
80004468:	97b6                	add	a5,a5,a3
8000446a:	c3d8                	sw	a4,4(a5)
}
8000446c:	0001                	nop
8000446e:	0141                	addi	sp,sp,16
80004470:	8082                	ret

Disassembly of section .text.pwmv2_set_fault_mode:

80004472 <pwmv2_set_fault_mode>:
 * @param pwm_x PWM base address, HPM_PWMx(x=0..n)
 * @param chn @ref pwm_channel_t
 * @param mode @ref pwm_fault_mode_t
 */
static inline void pwmv2_set_fault_mode(PWMV2_Type *pwm_x, pwm_channel_t chn, pwm_fault_mode_t mode)
{
80004472:	1141                	addi	sp,sp,-16
80004474:	c62a                	sw	a0,12(sp)
80004476:	87ae                	mv	a5,a1
80004478:	8732                	mv	a4,a2
8000447a:	00f105a3          	sb	a5,11(sp)
8000447e:	87ba                	mv	a5,a4
80004480:	00f10523          	sb	a5,10(sp)
    pwm_x->PWM[chn].CFG1 = (pwm_x->PWM[chn].CFG1 & ~PWMV2_PWM_CFG1_FAULT_MODE_MASK) | PWMV2_PWM_CFG1_FAULT_MODE_SET(mode);
80004484:	00b14783          	lbu	a5,11(sp)
80004488:	4732                	lw	a4,12(sp)
8000448a:	07c1                	addi	a5,a5,16
8000448c:	0792                	slli	a5,a5,0x4
8000448e:	97ba                	add	a5,a5,a4
80004490:	43d8                	lw	a4,4(a5)
80004492:	fd0007b7          	lui	a5,0xfd000
80004496:	17fd                	addi	a5,a5,-1 # fcffffff <__AHB_SRAM_segment_end__+0xcdf7fff>
80004498:	00f776b3          	and	a3,a4,a5
8000449c:	00a14783          	lbu	a5,10(sp)
800044a0:	01879713          	slli	a4,a5,0x18
800044a4:	030007b7          	lui	a5,0x3000
800044a8:	8f7d                	and	a4,a4,a5
800044aa:	00b14783          	lbu	a5,11(sp)
800044ae:	8f55                	or	a4,a4,a3
800044b0:	46b2                	lw	a3,12(sp)
800044b2:	07c1                	addi	a5,a5,16 # 3000010 <__NONCACHEABLE_RAM_segment_end__+0x1dc0010>
800044b4:	0792                	slli	a5,a5,0x4
800044b6:	97b6                	add	a5,a5,a3
800044b8:	c3d8                	sw	a4,4(a5)
}
800044ba:	0001                	nop
800044bc:	0141                	addi	sp,sp,16
800044be:	8082                	ret

Disassembly of section .text.pwmv2_set_trigout_cmp_index:

800044c0 <pwmv2_set_trigout_cmp_index>:
 * @param pwm_x PWM base address, HPM_PWMx(x=0..n)
 * @param trigmux_chn @ref pwm_channel_t
 * @param cmp_index cmp index
 */
static inline void pwmv2_set_trigout_cmp_index(PWMV2_Type *pwm_x, pwm_channel_t trigmux_chn, uint8_t cmp_index)
{
800044c0:	1141                	addi	sp,sp,-16
800044c2:	c62a                	sw	a0,12(sp)
800044c4:	87ae                	mv	a5,a1
800044c6:	8732                	mv	a4,a2
800044c8:	00f105a3          	sb	a5,11(sp)
800044cc:	87ba                	mv	a5,a4
800044ce:	00f10523          	sb	a5,10(sp)
    pwm_x->TRIGGER_CFG[trigmux_chn] = (pwm_x->TRIGGER_CFG[trigmux_chn] & ~PWMV2_TRIGGER_CFG_TRIGGER_OUT_SEL_MASK) | PWMV2_TRIGGER_CFG_TRIGGER_OUT_SEL_SET(cmp_index);
800044d2:	00b14783          	lbu	a5,11(sp)
800044d6:	4732                	lw	a4,12(sp)
800044d8:	06078793          	addi	a5,a5,96
800044dc:	078a                	slli	a5,a5,0x2
800044de:	97ba                	add	a5,a5,a4
800044e0:	439c                	lw	a5,0(a5)
800044e2:	fe07f693          	andi	a3,a5,-32
800044e6:	00a14783          	lbu	a5,10(sp)
800044ea:	01f7f713          	andi	a4,a5,31
800044ee:	00b14783          	lbu	a5,11(sp)
800044f2:	8f55                	or	a4,a4,a3
800044f4:	46b2                	lw	a3,12(sp)
800044f6:	06078793          	addi	a5,a5,96
800044fa:	078a                	slli	a5,a5,0x2
800044fc:	97b6                	add	a5,a5,a3
800044fe:	c398                	sw	a4,0(a5)
}
80004500:	0001                	nop
80004502:	0141                	addi	sp,sp,16
80004504:	8082                	ret

Disassembly of section .text.pwmv2_enable_shadow_lock_feature:

80004506 <pwmv2_enable_shadow_lock_feature>:
 * @brief Using the Shadow Register Function
 *
 * @param pwm_x PWM base address, HPM_PWMx(x=0..n)
 */
static inline void pwmv2_enable_shadow_lock_feature(PWMV2_Type *pwm_x)
{
80004506:	1141                	addi	sp,sp,-16
80004508:	c62a                	sw	a0,12(sp)
    pwm_x->GLB_CTRL2 |= PWMV2_GLB_CTRL2_SHADOW_LOCK_EN_MASK;
8000450a:	47b2                	lw	a5,12(sp)
8000450c:	1f47a783          	lw	a5,500(a5)
80004510:	0017e713          	ori	a4,a5,1
80004514:	47b2                	lw	a5,12(sp)
80004516:	1ee7aa23          	sw	a4,500(a5)
}
8000451a:	0001                	nop
8000451c:	0141                	addi	sp,sp,16
8000451e:	8082                	ret

Disassembly of section .text.pwmv2_reload_select_input_trigger:

80004520 <pwmv2_reload_select_input_trigger>:
 * @param pwm_x PWM base address, HPM_PWMx(x=0..n)
 * @param counter @ref pwm_counter_t
 * @param trig_index trig index
 */
static inline void pwmv2_reload_select_input_trigger(PWMV2_Type *pwm_x, pwm_counter_t counter, uint8_t trig_index)
{
80004520:	1141                	addi	sp,sp,-16
80004522:	c62a                	sw	a0,12(sp)
80004524:	87ae                	mv	a5,a1
80004526:	8732                	mv	a4,a2
80004528:	00f105a3          	sb	a5,11(sp)
8000452c:	87ba                	mv	a5,a4
8000452e:	00f10523          	sb	a5,10(sp)
    pwm_x->CNT[counter].CFG0 = (pwm_x->CNT[counter].CFG0 & ~(PWMV2_CNT_CFG0_RLD_TRIG_SEL_MASK)) | PWMV2_CNT_CFG0_RLD_TRIG_SEL_SET(trig_index);
80004532:	00b14783          	lbu	a5,11(sp)
80004536:	4732                	lw	a4,12(sp)
80004538:	05078793          	addi	a5,a5,80
8000453c:	0792                	slli	a5,a5,0x4
8000453e:	97ba                	add	a5,a5,a4
80004540:	4398                	lw	a4,0(a5)
80004542:	77e5                	lui	a5,0xffff9
80004544:	17fd                	addi	a5,a5,-1 # ffff8fff <__AHB_SRAM_segment_end__+0xfdf0fff>
80004546:	00f776b3          	and	a3,a4,a5
8000454a:	00a14783          	lbu	a5,10(sp)
8000454e:	00c79713          	slli	a4,a5,0xc
80004552:	679d                	lui	a5,0x7
80004554:	8f7d                	and	a4,a4,a5
80004556:	00b14783          	lbu	a5,11(sp)
8000455a:	8f55                	or	a4,a4,a3
8000455c:	46b2                	lw	a3,12(sp)
8000455e:	05078793          	addi	a5,a5,80 # 7050 <__HEAPSIZE__+0x3050>
80004562:	0792                	slli	a5,a5,0x4
80004564:	97b6                	add	a5,a5,a3
80004566:	c398                	sw	a4,0(a5)
}
80004568:	0001                	nop
8000456a:	0141                	addi	sp,sp,16
8000456c:	8082                	ret

Disassembly of section .text.pwmv2_counter_select_data_offset_from_shadow_value:

8000456e <pwmv2_counter_select_data_offset_from_shadow_value>:
 * @param pwm_x PWM base address, HPM_PWMx(x=0..n)
 * @param counter @ref pwm_counter_t
 * @param index shadow index
 */
static inline void pwmv2_counter_select_data_offset_from_shadow_value(PWMV2_Type *pwm_x, pwm_counter_t counter, uint8_t index)
{
8000456e:	1141                	addi	sp,sp,-16
80004570:	c62a                	sw	a0,12(sp)
80004572:	87ae                	mv	a5,a1
80004574:	8732                	mv	a4,a2
80004576:	00f105a3          	sb	a5,11(sp)
8000457a:	87ba                	mv	a5,a4
8000457c:	00f10523          	sb	a5,10(sp)
    pwm_x->CNT[counter].CFG1 = (pwm_x->CNT[counter].CFG1 & ~PWMV2_CNT_CFG1_CNT_IN_OFF_MASK) | PWMV2_CNT_CFG1_CNT_IN_OFF_SET(index);
80004580:	00b14783          	lbu	a5,11(sp)
80004584:	4732                	lw	a4,12(sp)
80004586:	05078793          	addi	a5,a5,80
8000458a:	0792                	slli	a5,a5,0x4
8000458c:	97ba                	add	a5,a5,a4
8000458e:	43dc                	lw	a5,4(a5)
80004590:	fe07f693          	andi	a3,a5,-32
80004594:	00a14783          	lbu	a5,10(sp)
80004598:	01f7f713          	andi	a4,a5,31
8000459c:	00b14783          	lbu	a5,11(sp)
800045a0:	8f55                	or	a4,a4,a3
800045a2:	46b2                	lw	a3,12(sp)
800045a4:	05078793          	addi	a5,a5,80
800045a8:	0792                	slli	a5,a5,0x4
800045aa:	97b6                	add	a5,a5,a3
800045ac:	c3d8                	sw	a4,4(a5)
}
800045ae:	0001                	nop
800045b0:	0141                	addi	sp,sp,16
800045b2:	8082                	ret

Disassembly of section .text.pwmv2_counter_burst_disable:

800045b4 <pwmv2_counter_burst_disable>:
 *
 * @param pwm_x PWM base address, HPM_PWMx(x=0..n)
 * @param counter @ref pwm_counter_t
 */
static inline void pwmv2_counter_burst_disable(PWMV2_Type *pwm_x, pwm_counter_t counter)
{
800045b4:	1141                	addi	sp,sp,-16
800045b6:	c62a                	sw	a0,12(sp)
800045b8:	87ae                	mv	a5,a1
800045ba:	00f105a3          	sb	a5,11(sp)
    pwm_x->CNT[counter].CFG3 |= PWMV2_CNT_CFG3_CNT_BURST_MASK;
800045be:	00b14783          	lbu	a5,11(sp)
800045c2:	4732                	lw	a4,12(sp)
800045c4:	05078793          	addi	a5,a5,80
800045c8:	0792                	slli	a5,a5,0x4
800045ca:	97ba                	add	a5,a5,a4
800045cc:	47d4                	lw	a3,12(a5)
800045ce:	00b14783          	lbu	a5,11(sp)
800045d2:	6741                	lui	a4,0x10
800045d4:	177d                	addi	a4,a4,-1 # ffff <__FLASH_segment_used_size__+0x760b>
800045d6:	8f55                	or	a4,a4,a3
800045d8:	46b2                	lw	a3,12(sp)
800045da:	05078793          	addi	a5,a5,80
800045de:	0792                	slli	a5,a5,0x4
800045e0:	97b6                	add	a5,a5,a3
800045e2:	c7d8                	sw	a4,12(a5)
}
800045e4:	0001                	nop
800045e6:	0141                	addi	sp,sp,16
800045e8:	8082                	ret

Disassembly of section .text.pwmv2_start_pwm_output:

800045ea <pwmv2_start_pwm_output>:
 *
 * @param pwm_x PWM base address, HPM_PWMx(x=0..n)
 * @param counter @ref pwm_counter_t
 */
static inline void pwmv2_start_pwm_output(PWMV2_Type *pwm_x, pwm_counter_t counter)
{
800045ea:	1141                	addi	sp,sp,-16
800045ec:	c62a                	sw	a0,12(sp)
800045ee:	87ae                	mv	a5,a1
800045f0:	00f105a3          	sb	a5,11(sp)
    pwm_x->CNT_GLBCFG |= PWMV2_CNT_GLBCFG_CNT_SW_START_SET((1 << counter));
800045f4:	47b2                	lw	a5,12(sp)
800045f6:	5407a703          	lw	a4,1344(a5)
800045fa:	00b14783          	lbu	a5,11(sp)
800045fe:	4685                	li	a3,1
80004600:	00f697b3          	sll	a5,a3,a5
80004604:	01079693          	slli	a3,a5,0x10
80004608:	000f07b7          	lui	a5,0xf0
8000460c:	8ff5                	and	a5,a5,a3
8000460e:	8f5d                	or	a4,a4,a5
80004610:	47b2                	lw	a5,12(sp)
80004612:	54e7a023          	sw	a4,1344(a5) # f0540 <__AXI_SRAM_segment_size__+0xc0540>
}
80004616:	0001                	nop
80004618:	0141                	addi	sp,sp,16
8000461a:	8082                	ret

Disassembly of section .text.pwmv2_enable_counter:

8000461c <pwmv2_enable_counter>:
 *
 * @param pwm_x PWM base address, HPM_PWMx(x=0..n)
 * @param counter @ref pwm_counter_t
 */
static inline void pwmv2_enable_counter(PWMV2_Type *pwm_x, pwm_counter_t counter)
{
8000461c:	1141                	addi	sp,sp,-16
8000461e:	c62a                	sw	a0,12(sp)
80004620:	87ae                	mv	a5,a1
80004622:	00f105a3          	sb	a5,11(sp)
    pwm_x->CNT_GLBCFG |= PWMV2_CNT_GLBCFG_TIMER_ENABLE_SET((1 << counter));
80004626:	47b2                	lw	a5,12(sp)
80004628:	5407a703          	lw	a4,1344(a5)
8000462c:	00b14783          	lbu	a5,11(sp)
80004630:	4685                	li	a3,1
80004632:	00f697b3          	sll	a5,a3,a5
80004636:	8bbd                	andi	a5,a5,15
80004638:	8f5d                	or	a4,a4,a5
8000463a:	47b2                	lw	a5,12(sp)
8000463c:	54e7a023          	sw	a4,1344(a5)
}
80004640:	0001                	nop
80004642:	0141                	addi	sp,sp,16
80004644:	8082                	ret

Disassembly of section .text.pwmv2_select_cmp_source:

80004646 <pwmv2_select_cmp_source>:
 * @param cmp_index cmp index
 * @param cmp_sel @ref pwm_cmp_source_t
 * @param index source index
 */
static inline void pwmv2_select_cmp_source(PWMV2_Type *pwm_x, uint8_t cmp_index, pwm_cmp_source_t cmp_sel, uint8_t index)
{
80004646:	1141                	addi	sp,sp,-16
80004648:	c62a                	sw	a0,12(sp)
8000464a:	87ae                	mv	a5,a1
8000464c:	8736                	mv	a4,a3
8000464e:	00f105a3          	sb	a5,11(sp)
80004652:	87b2                	mv	a5,a2
80004654:	00f10523          	sb	a5,10(sp)
80004658:	87ba                	mv	a5,a4
8000465a:	00f104a3          	sb	a5,9(sp)
    pwm_x->CMP[cmp_index].CFG = (pwm_x->CMP[cmp_index].CFG & ~PWMV2_CMP_CFG_CMP_IN_SEL_MASK) | PWMV2_CMP_CFG_CMP_IN_SEL_SET((cmp_sel + index));
8000465e:	00b14783          	lbu	a5,11(sp)
80004662:	4732                	lw	a4,12(sp)
80004664:	08078793          	addi	a5,a5,128
80004668:	0792                	slli	a5,a5,0x4
8000466a:	97ba                	add	a5,a5,a4
8000466c:	4398                	lw	a4,0(a5)
8000466e:	ffc107b7          	lui	a5,0xffc10
80004672:	17fd                	addi	a5,a5,-1 # ffc0ffff <__AHB_SRAM_segment_end__+0xfa07fff>
80004674:	00f776b3          	and	a3,a4,a5
80004678:	00a14703          	lbu	a4,10(sp)
8000467c:	00914783          	lbu	a5,9(sp)
80004680:	97ba                	add	a5,a5,a4
80004682:	01079713          	slli	a4,a5,0x10
80004686:	003f07b7          	lui	a5,0x3f0
8000468a:	8f7d                	and	a4,a4,a5
8000468c:	00b14783          	lbu	a5,11(sp)
80004690:	8f55                	or	a4,a4,a3
80004692:	46b2                	lw	a3,12(sp)
80004694:	08078793          	addi	a5,a5,128 # 3f0080 <__DLM_segment_end__+0x1d0080>
80004698:	0792                	slli	a5,a5,0x4
8000469a:	97b6                	add	a5,a5,a3
8000469c:	c398                	sw	a4,0(a5)
}
8000469e:	0001                	nop
800046a0:	0141                	addi	sp,sp,16
800046a2:	8082                	ret

Disassembly of section .text.adc16_init_pmt_dma:

800046a4 <adc16_init_pmt_dma>:
 *
 * @param[in] ptr An ADC16 peripheral base address.
 * @param[in] addr A start address of DMA write operation.
 */
static inline void adc16_init_pmt_dma(ADC16_Type *ptr, uint32_t addr)
{
800046a4:	1141                	addi	sp,sp,-16
800046a6:	c62a                	sw	a0,12(sp)
800046a8:	c42e                	sw	a1,8(sp)
    ptr->TRG_DMA_ADDR = addr & ADC16_TRG_DMA_ADDR_TRG_DMA_ADDR_MASK;
800046aa:	47a2                	lw	a5,8(sp)
800046ac:	ffc7f713          	andi	a4,a5,-4
800046b0:	47b2                	lw	a5,12(sp)
800046b2:	db98                	sw	a4,48(a5)
}
800046b4:	0001                	nop
800046b6:	0141                	addi	sp,sp,16
800046b8:	8082                	ret

Disassembly of section .text.gpio_toggle_pin:

800046ba <gpio_toggle_pin>:
 * @param ptr GPIO base address
 * @param port Port index
 * @param pin Pin index
 */
static inline void gpio_toggle_pin(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
800046ba:	1141                	addi	sp,sp,-16
800046bc:	c62a                	sw	a0,12(sp)
800046be:	c42e                	sw	a1,8(sp)
800046c0:	87b2                	mv	a5,a2
800046c2:	00f103a3          	sb	a5,7(sp)
    ptr->DO[port].TOGGLE = 1 << pin;
800046c6:	00714783          	lbu	a5,7(sp)
800046ca:	4705                	li	a4,1
800046cc:	00f717b3          	sll	a5,a4,a5
800046d0:	86be                	mv	a3,a5
800046d2:	4732                	lw	a4,12(sp)
800046d4:	47a2                	lw	a5,8(sp)
800046d6:	07c1                	addi	a5,a5,16
800046d8:	0792                	slli	a5,a5,0x4
800046da:	97ba                	add	a5,a5,a4
800046dc:	c7d4                	sw	a3,12(a5)
}
800046de:	0001                	nop
800046e0:	0141                	addi	sp,sp,16
800046e2:	8082                	ret

Disassembly of section .text.gpio_get_port_interrupt_flags:

800046e4 <gpio_get_port_interrupt_flags>:
 * @param port Port index
 *
 * @return Current interrupt flags on specific port
 */
static inline uint32_t gpio_get_port_interrupt_flags(GPIO_Type *ptr, uint32_t port)
{
800046e4:	1141                	addi	sp,sp,-16
800046e6:	c62a                	sw	a0,12(sp)
800046e8:	c42e                	sw	a1,8(sp)
    return ptr->IF[port].VALUE;
800046ea:	4732                	lw	a4,12(sp)
800046ec:	47a2                	lw	a5,8(sp)
800046ee:	03078793          	addi	a5,a5,48
800046f2:	0792                	slli	a5,a5,0x4
800046f4:	97ba                	add	a5,a5,a4
800046f6:	439c                	lw	a5,0(a5)
}
800046f8:	853e                	mv	a0,a5
800046fa:	0141                	addi	sp,sp,16
800046fc:	8082                	ret

Disassembly of section .text.synt_enable_counter:

800046fe <synt_enable_counter>:
#ifdef __cplusplus
extern "C" {
#endif

static inline void synt_enable_counter(SYNT_Type *ptr, bool enable)
{
800046fe:	1141                	addi	sp,sp,-16
80004700:	c62a                	sw	a0,12(sp)
80004702:	87ae                	mv	a5,a1
80004704:	00f105a3          	sb	a5,11(sp)
    ptr->GCR = (ptr->GCR & ~(SYNT_GCR_CEN_MASK)) | SYNT_GCR_CEN_SET(enable);
80004708:	47b2                	lw	a5,12(sp)
8000470a:	439c                	lw	a5,0(a5)
8000470c:	ffe7f713          	andi	a4,a5,-2
80004710:	00b14783          	lbu	a5,11(sp)
80004714:	8f5d                	or	a4,a4,a5
80004716:	47b2                	lw	a5,12(sp)
80004718:	c398                	sw	a4,0(a5)
}
8000471a:	0001                	nop
8000471c:	0141                	addi	sp,sp,16
8000471e:	8082                	ret

Disassembly of section .text.synt_reset_counter:

80004720 <synt_reset_counter>:

static inline void synt_reset_counter(SYNT_Type *ptr)
{
80004720:	1141                	addi	sp,sp,-16
80004722:	c62a                	sw	a0,12(sp)
    ptr->GCR |= SYNT_GCR_CRST_MASK;
80004724:	47b2                	lw	a5,12(sp)
80004726:	439c                	lw	a5,0(a5)
80004728:	0027e713          	ori	a4,a5,2
8000472c:	47b2                	lw	a5,12(sp)
8000472e:	c398                	sw	a4,0(a5)
    ptr->GCR &= ~SYNT_GCR_CRST_MASK;
80004730:	47b2                	lw	a5,12(sp)
80004732:	439c                	lw	a5,0(a5)
80004734:	ffd7f713          	andi	a4,a5,-3
80004738:	47b2                	lw	a5,12(sp)
8000473a:	c398                	sw	a4,0(a5)
}
8000473c:	0001                	nop
8000473e:	0141                	addi	sp,sp,16
80004740:	8082                	ret

Disassembly of section .text.synt_set_comparator:

80004742 <synt_set_comparator>:

static inline hpm_stat_t synt_set_comparator(SYNT_Type *ptr,
                                       uint8_t cmp_index,
                                       uint32_t count)
{
80004742:	1141                	addi	sp,sp,-16
80004744:	c62a                	sw	a0,12(sp)
80004746:	87ae                	mv	a5,a1
80004748:	c232                	sw	a2,4(sp)
8000474a:	00f105a3          	sb	a5,11(sp)
#if defined(SYNT_SOC_HAS_EXTENSION_CMP) && SYNT_SOC_HAS_EXTENSION_CMP
    if (cmp_index > SYNT_CMP_15) {
8000474e:	00b14703          	lbu	a4,11(sp)
80004752:	47bd                	li	a5,15
80004754:	00e7f463          	bgeu	a5,a4,8000475c <.L38>
#else
    if (cmp_index > SYNT_CMP_3) {
#endif
        return status_invalid_argument;
80004758:	4789                	li	a5,2
8000475a:	a811                	j	8000476e <.L39>

8000475c <.L38>:
    }
    ptr->CMP[cmp_index] = SYNT_CMP_CMP_SET(count);
8000475c:	00b14783          	lbu	a5,11(sp)
80004760:	4732                	lw	a4,12(sp)
80004762:	07a1                	addi	a5,a5,8
80004764:	078a                	slli	a5,a5,0x2
80004766:	97ba                	add	a5,a5,a4
80004768:	4712                	lw	a4,4(sp)
8000476a:	c398                	sw	a4,0(a5)
    return status_success;
8000476c:	4781                	li	a5,0

8000476e <.L39>:
}
8000476e:	853e                	mv	a0,a5
80004770:	0141                	addi	sp,sp,16
80004772:	8082                	ret

Disassembly of section .text.synt_set_reload:

80004774 <synt_set_reload>:

static inline void synt_set_reload(SYNT_Type *ptr, uint32_t reload_count)
{
80004774:	1141                	addi	sp,sp,-16
80004776:	c62a                	sw	a0,12(sp)
80004778:	c42e                	sw	a1,8(sp)
    ptr->RLD = SYNT_RLD_RLD_SET(reload_count);
8000477a:	47b2                	lw	a5,12(sp)
8000477c:	4722                	lw	a4,8(sp)
8000477e:	c3d8                	sw	a4,4(a5)
}
80004780:	0001                	nop
80004782:	0141                	addi	sp,sp,16
80004784:	8082                	ret

Disassembly of section .text.pwm_fault_async:

80004786 <pwm_fault_async>:
__IO uint8_t trig_complete_flag;

void FOC_voltage(float Vd_set, float Vq_set, float phase);

void pwm_fault_async(void)
{
80004786:	1101                	addi	sp,sp,-32
80004788:	ce06                	sw	ra,28(sp)
    pwmv2_async_fault_source_config_t fault_cfg;

    fault_cfg.async_signal_from_pad_index = BOARD_APP_PWM_FAULT_PIN;
8000478a:	4795                	li	a5,5
8000478c:	00f10623          	sb	a5,12(sp)
    fault_cfg.fault_async_pad_level = pad_fault_active_high;
80004790:	000106a3          	sb	zero,13(sp)
    pwmv2_config_async_fault_source(PWM, PWM_OUTPUT_PIN1, &fault_cfg);
80004794:	007c                	addi	a5,sp,12
80004796:	863e                	mv	a2,a5
80004798:	4581                	li	a1,0
8000479a:	f0420537          	lui	a0,0xf0420
8000479e:	551010ef          	jal	800064ee <pwmv2_config_async_fault_source>
    pwmv2_config_async_fault_source(PWM, PWM_OUTPUT_PIN2, &fault_cfg);
800047a2:	007c                	addi	a5,sp,12
800047a4:	863e                	mv	a2,a5
800047a6:	4585                	li	a1,1
800047a8:	f0420537          	lui	a0,0xf0420
800047ac:	543010ef          	jal	800064ee <pwmv2_config_async_fault_source>
    pwmv2_config_async_fault_source(PWM, PWM_OUTPUT_PIN3, &fault_cfg);
800047b0:	007c                	addi	a5,sp,12
800047b2:	863e                	mv	a2,a5
800047b4:	4589                	li	a1,2
800047b6:	f0420537          	lui	a0,0xf0420
800047ba:	535010ef          	jal	800064ee <pwmv2_config_async_fault_source>
    pwmv2_set_fault_mode(PWM, PWM_OUTPUT_PIN1, pwm_fault_output_0);
800047be:	4601                	li	a2,0
800047c0:	4581                	li	a1,0
800047c2:	f0420537          	lui	a0,0xf0420
800047c6:	3175                	jal	80004472 <pwmv2_set_fault_mode>
    pwmv2_set_fault_mode(PWM, PWM_OUTPUT_PIN2, pwm_fault_output_0);
800047c8:	4601                	li	a2,0
800047ca:	4585                	li	a1,1
800047cc:	f0420537          	lui	a0,0xf0420
800047d0:	314d                	jal	80004472 <pwmv2_set_fault_mode>
    pwmv2_set_fault_mode(PWM, PWM_OUTPUT_PIN3, pwm_fault_output_0);
800047d2:	4601                	li	a2,0
800047d4:	4589                	li	a1,2
800047d6:	f0420537          	lui	a0,0xf0420
800047da:	3961                	jal	80004472 <pwmv2_set_fault_mode>
    pwmv2_enable_async_fault(PWM, PWM_OUTPUT_PIN1);
800047dc:	4581                	li	a1,0
800047de:	f0420537          	lui	a0,0xf0420
800047e2:	061030ef          	jal	80008042 <pwmv2_enable_async_fault>
    pwmv2_enable_async_fault(PWM, PWM_OUTPUT_PIN2);
800047e6:	4585                	li	a1,1
800047e8:	f0420537          	lui	a0,0xf0420
800047ec:	057030ef          	jal	80008042 <pwmv2_enable_async_fault>
    pwmv2_enable_async_fault(PWM, PWM_OUTPUT_PIN3);
800047f0:	4589                	li	a1,2
800047f2:	f0420537          	lui	a0,0xf0420
800047f6:	04d030ef          	jal	80008042 <pwmv2_enable_async_fault>
}
800047fa:	0001                	nop
800047fc:	40f2                	lw	ra,28(sp)
800047fe:	6105                	addi	sp,sp,32
80004800:	8082                	ret

Disassembly of section .text.sync_start:

80004802 <sync_start>:
    synt_set_comparator(HPM_SYNT, SYNT_CMP_1, (reload >> 2));
    synt_set_comparator(HPM_SYNT, SYNT_CMP_2, (reload >> 1));
}

static void sync_start(void)
{
80004802:	1141                	addi	sp,sp,-16
80004804:	c606                	sw	ra,12(sp)
    synt_enable_counter(HPM_SYNT, true);
80004806:	4585                	li	a1,1
80004808:	f0464537          	lui	a0,0xf0464
8000480c:	3dcd                	jal	800046fe <synt_enable_counter>
}
8000480e:	0001                	nop
80004810:	40b2                	lw	ra,12(sp)
80004812:	0141                	addi	sp,sp,16
80004814:	8082                	ret

Disassembly of section .text.init_start_trgm_connect:

80004816 <init_start_trgm_connect>:
    synt_enable_counter(HPM_SYNT, false);
    synt_reset_counter(HPM_SYNT);
}

static void init_start_trgm_connect(void)
{
80004816:	7139                	addi	sp,sp,-64
80004818:	de06                	sw	ra,60(sp)
    trgm_output_t trgm0_io_config0 = {0};
8000481a:	d202                	sw	zero,36(sp)
8000481c:	d402                	sw	zero,40(sp)
8000481e:	d602                	sw	zero,44(sp)
    trgm0_io_config0.invert = 0;
80004820:	02010223          	sb	zero,36(sp)
    trgm0_io_config0.type = trgm_output_pulse_at_input_rising_edge;
80004824:	67c1                	lui	a5,0x10
80004826:	d43e                	sw	a5,40(sp)
    trgm0_io_config0.input = HPM_TRGM0_INPUT_SRC_SYNT_CH00;
80004828:	47a1                	li	a5,8
8000482a:	02f10623          	sb	a5,44(sp)
    trgm_output_config(HPM_TRGM0, BOARD_APP_TRGM_PWM_OUTPUT, &trgm0_io_config0);
8000482e:	105c                	addi	a5,sp,36
80004830:	863e                	mv	a2,a5
80004832:	45c1                	li	a1,16
80004834:	f047c537          	lui	a0,0xf047c
80004838:	3e71                	jal	800043d4 <trgm_output_config>

    trgm_output_t trgm0_io_config1 = {0};
8000483a:	cc02                	sw	zero,24(sp)
8000483c:	ce02                	sw	zero,28(sp)
8000483e:	d002                	sw	zero,32(sp)
    trgm0_io_config1.invert = 0;
80004840:	00010c23          	sb	zero,24(sp)
    trgm0_io_config1.type = trgm_output_pulse_at_input_rising_edge;
80004844:	67c1                	lui	a5,0x10
80004846:	ce3e                	sw	a5,28(sp)
    trgm0_io_config1.input = HPM_TRGM0_INPUT_SRC_SYNT_CH00;
80004848:	47a1                	li	a5,8
8000484a:	02f10023          	sb	a5,32(sp)
    trgm_output_config(HPM_TRGM0, BOARD_APP_TRGM_PWM_OUTPUT1, &trgm0_io_config1);
8000484e:	083c                	addi	a5,sp,24
80004850:	863e                	mv	a2,a5
80004852:	45c5                	li	a1,17
80004854:	f047c537          	lui	a0,0xf047c
80004858:	3eb5                	jal	800043d4 <trgm_output_config>

    trgm_output_t trgm0_io_config2 = {0};
8000485a:	c602                	sw	zero,12(sp)
8000485c:	c802                	sw	zero,16(sp)
8000485e:	ca02                	sw	zero,20(sp)
    trgm0_io_config2.invert = 0;
80004860:	00010623          	sb	zero,12(sp)
    trgm0_io_config2.type = trgm_output_pulse_at_input_rising_edge;
80004864:	67c1                	lui	a5,0x10
80004866:	c83e                	sw	a5,16(sp)
    trgm0_io_config2.input = HPM_TRGM0_INPUT_SRC_SYNT_CH00;
80004868:	47a1                	li	a5,8
8000486a:	00f10a23          	sb	a5,20(sp)
    trgm_output_config(HPM_TRGM0, BOARD_APP_TRGM_PWM_OUTPUT2, &trgm0_io_config2);
8000486e:	007c                	addi	a5,sp,12
80004870:	863e                	mv	a2,a5
80004872:	45c9                	li	a1,18
80004874:	f047c537          	lui	a0,0xf047c
80004878:	3eb1                	jal	800043d4 <trgm_output_config>
}
8000487a:	0001                	nop
8000487c:	50f2                	lw	ra,60(sp)
8000487e:	6121                	addi	sp,sp,64
80004880:	8082                	ret

Disassembly of section .text.pwm_sync_three_submodules_handware_config:

80004882 <pwm_sync_three_submodules_handware_config>:
    trgm0_io_config2.input = HPM_TRGM0_INPUT_SRC_SYNT_CH02;
    trgm_output_config(HPM_TRGM0, BOARD_APP_TRGM_PWM_OUTPUT2, &trgm0_io_config2);
}

static void pwm_sync_three_submodules_handware_config(void)
{
80004882:	1141                	addi	sp,sp,-16
80004884:	c606                	sw	ra,12(sp)

    pwmv2_enable_shadow_lock_feature(PWM);
80004886:	f0420537          	lui	a0,0xf0420
8000488a:	39b5                	jal	80004506 <pwmv2_enable_shadow_lock_feature>
    pwmv2_shadow_register_unlock(PWM);
8000488c:	f0420537          	lui	a0,0xf0420
80004890:	3e69                	jal	8000442a <pwmv2_shadow_register_unlock>
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(0), reload, 0, 0);
80004892:	012007b7          	lui	a5,0x1200
80004896:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
8000489a:	4701                	li	a4,0
8000489c:	4681                	li	a3,0
8000489e:	863e                	mv	a2,a5
800048a0:	4581                	li	a1,0
800048a2:	f0420537          	lui	a0,0xf0420
800048a6:	728030ef          	jal	80007fce <pwmv2_set_shadow_val>
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(1), reload + 1, 0, 0);
800048aa:	012007b7          	lui	a5,0x1200
800048ae:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
800048b2:	0785                	addi	a5,a5,1
800048b4:	4701                	li	a4,0
800048b6:	4681                	li	a3,0
800048b8:	863e                	mv	a2,a5
800048ba:	4585                	li	a1,1
800048bc:	f0420537          	lui	a0,0xf0420
800048c0:	70e030ef          	jal	80007fce <pwmv2_set_shadow_val>
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(2), reload, 0, 0);
800048c4:	012007b7          	lui	a5,0x1200
800048c8:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
800048cc:	4701                	li	a4,0
800048ce:	4681                	li	a3,0
800048d0:	863e                	mv	a2,a5
800048d2:	4589                	li	a1,2
800048d4:	f0420537          	lui	a0,0xf0420
800048d8:	6f6030ef          	jal	80007fce <pwmv2_set_shadow_val>
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(3), reload + 1, 0, 0);
800048dc:	012007b7          	lui	a5,0x1200
800048e0:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
800048e4:	0785                	addi	a5,a5,1
800048e6:	4701                	li	a4,0
800048e8:	4681                	li	a3,0
800048ea:	863e                	mv	a2,a5
800048ec:	458d                	li	a1,3
800048ee:	f0420537          	lui	a0,0xf0420
800048f2:	6dc030ef          	jal	80007fce <pwmv2_set_shadow_val>
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(4), reload, 0, 0);
800048f6:	012007b7          	lui	a5,0x1200
800048fa:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
800048fe:	4701                	li	a4,0
80004900:	4681                	li	a3,0
80004902:	863e                	mv	a2,a5
80004904:	4591                	li	a1,4
80004906:	f0420537          	lui	a0,0xf0420
8000490a:	6c4030ef          	jal	80007fce <pwmv2_set_shadow_val>
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(5), reload + 1, 0, 0);
8000490e:	012007b7          	lui	a5,0x1200
80004912:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
80004916:	0785                	addi	a5,a5,1
80004918:	4701                	li	a4,0
8000491a:	4681                	li	a3,0
8000491c:	863e                	mv	a2,a5
8000491e:	4595                	li	a1,5
80004920:	f0420537          	lui	a0,0xf0420
80004924:	6aa030ef          	jal	80007fce <pwmv2_set_shadow_val>
    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(6), reload, 0, 0);
80004928:	012007b7          	lui	a5,0x1200
8000492c:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
80004930:	4701                	li	a4,0
80004932:	4681                	li	a3,0
80004934:	863e                	mv	a2,a5
80004936:	4599                	li	a1,6
80004938:	f0420537          	lui	a0,0xf0420
8000493c:	692030ef          	jal	80007fce <pwmv2_set_shadow_val>

    pwmv2_counter_select_data_offset_from_shadow_value(PWM, pwm_counter_0, PWMV2_SHADOW_INDEX(0));
80004940:	4601                	li	a2,0
80004942:	4581                	li	a1,0
80004944:	f0420537          	lui	a0,0xf0420
80004948:	311d                	jal	8000456e <pwmv2_counter_select_data_offset_from_shadow_value>
    pwmv2_counter_select_data_offset_from_shadow_value(PWM, pwm_counter_1, PWMV2_SHADOW_INDEX(0));
8000494a:	4601                	li	a2,0
8000494c:	4585                	li	a1,1
8000494e:	f0420537          	lui	a0,0xf0420
80004952:	3931                	jal	8000456e <pwmv2_counter_select_data_offset_from_shadow_value>
    pwmv2_counter_select_data_offset_from_shadow_value(PWM, pwm_counter_2, PWMV2_SHADOW_INDEX(0));
80004954:	4601                	li	a2,0
80004956:	4589                	li	a1,2
80004958:	f0420537          	lui	a0,0xf0420
8000495c:	3909                	jal	8000456e <pwmv2_counter_select_data_offset_from_shadow_value>

    //UH
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(0), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(1));
8000495e:	4685                	li	a3,1
80004960:	4601                	li	a2,0
80004962:	4581                	li	a1,0
80004964:	f0420537          	lui	a0,0xf0420
80004968:	39f9                	jal	80004646 <pwmv2_select_cmp_source>
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(1), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(2));
8000496a:	4689                	li	a3,2
8000496c:	4601                	li	a2,0
8000496e:	4585                	li	a1,1
80004970:	f0420537          	lui	a0,0xf0420
80004974:	39c9                	jal	80004646 <pwmv2_select_cmp_source>
    //UL
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(6), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(1));
80004976:	4685                	li	a3,1
80004978:	4601                	li	a2,0
8000497a:	4599                	li	a1,6
8000497c:	f0420537          	lui	a0,0xf0420
80004980:	31d9                	jal	80004646 <pwmv2_select_cmp_source>
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(7), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(2));
80004982:	4689                	li	a3,2
80004984:	4601                	li	a2,0
80004986:	459d                	li	a1,7
80004988:	f0420537          	lui	a0,0xf0420
8000498c:	396d                	jal	80004646 <pwmv2_select_cmp_source>
    //VH
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(2), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(3));
8000498e:	468d                	li	a3,3
80004990:	4601                	li	a2,0
80004992:	4589                	li	a1,2
80004994:	f0420537          	lui	a0,0xf0420
80004998:	317d                	jal	80004646 <pwmv2_select_cmp_source>
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(3), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(4));
8000499a:	4691                	li	a3,4
8000499c:	4601                	li	a2,0
8000499e:	458d                	li	a1,3
800049a0:	f0420537          	lui	a0,0xf0420
800049a4:	314d                	jal	80004646 <pwmv2_select_cmp_source>
    //VL
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(8), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(3));
800049a6:	468d                	li	a3,3
800049a8:	4601                	li	a2,0
800049aa:	45a1                	li	a1,8
800049ac:	f0420537          	lui	a0,0xf0420
800049b0:	3959                	jal	80004646 <pwmv2_select_cmp_source>
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(9), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(4));
800049b2:	4691                	li	a3,4
800049b4:	4601                	li	a2,0
800049b6:	45a5                	li	a1,9
800049b8:	f0420537          	lui	a0,0xf0420
800049bc:	3169                	jal	80004646 <pwmv2_select_cmp_source>
    //WH
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(4), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(5));
800049be:	4695                	li	a3,5
800049c0:	4601                	li	a2,0
800049c2:	4591                	li	a1,4
800049c4:	f0420537          	lui	a0,0xf0420
800049c8:	39bd                	jal	80004646 <pwmv2_select_cmp_source>
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(5), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(6));
800049ca:	4699                	li	a3,6
800049cc:	4601                	li	a2,0
800049ce:	4595                	li	a1,5
800049d0:	f0420537          	lui	a0,0xf0420
800049d4:	398d                	jal	80004646 <pwmv2_select_cmp_source>
    //WL
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(10), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(5));
800049d6:	4695                	li	a3,5
800049d8:	4601                	li	a2,0
800049da:	45a9                	li	a1,10
800049dc:	f0420537          	lui	a0,0xf0420
800049e0:	319d                	jal	80004646 <pwmv2_select_cmp_source>
    pwmv2_select_cmp_source(PWM, PWMV2_CMP_INDEX(11), cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(6));
800049e2:	4699                	li	a3,6
800049e4:	4601                	li	a2,0
800049e6:	45ad                	li	a1,11
800049e8:	f0420537          	lui	a0,0xf0420
800049ec:	39a9                	jal	80004646 <pwmv2_select_cmp_source>

    pwmv2_reload_select_input_trigger(PWM, pwm_counter_0, 0);
800049ee:	4601                	li	a2,0
800049f0:	4581                	li	a1,0
800049f2:	f0420537          	lui	a0,0xf0420
800049f6:	362d                	jal	80004520 <pwmv2_reload_select_input_trigger>
    pwmv2_reload_select_input_trigger(PWM, pwm_counter_1, 1);
800049f8:	4605                	li	a2,1
800049fa:	4585                	li	a1,1
800049fc:	f0420537          	lui	a0,0xf0420
80004a00:	3605                	jal	80004520 <pwmv2_reload_select_input_trigger>
    pwmv2_reload_select_input_trigger(PWM, pwm_counter_2, 2);
80004a02:	4609                	li	a2,2
80004a04:	4589                	li	a1,2
80004a06:	f0420537          	lui	a0,0xf0420
80004a0a:	3e19                	jal	80004520 <pwmv2_reload_select_input_trigger>

    pwmv2_set_reload_update_time(PWM, pwm_counter_0, pwm_reload_update_on_trigger);
80004a0c:	460d                	li	a2,3
80004a0e:	4581                	li	a1,0
80004a10:	f0420537          	lui	a0,0xf0420
80004a14:	6c2030ef          	jal	800080d6 <pwmv2_set_reload_update_time>
    pwmv2_set_reload_update_time(PWM, pwm_counter_1, pwm_reload_update_on_trigger);
80004a18:	460d                	li	a2,3
80004a1a:	4585                	li	a1,1
80004a1c:	f0420537          	lui	a0,0xf0420
80004a20:	6b6030ef          	jal	800080d6 <pwmv2_set_reload_update_time>
    pwmv2_set_reload_update_time(PWM, pwm_counter_2, pwm_reload_update_on_trigger);
80004a24:	460d                	li	a2,3
80004a26:	4589                	li	a1,2
80004a28:	f0420537          	lui	a0,0xf0420
80004a2c:	6aa030ef          	jal	800080d6 <pwmv2_set_reload_update_time>

    pwmv2_counter_burst_disable(PWM, pwm_counter_0);
80004a30:	4581                	li	a1,0
80004a32:	f0420537          	lui	a0,0xf0420
80004a36:	3ebd                	jal	800045b4 <pwmv2_counter_burst_disable>
    pwmv2_counter_burst_disable(PWM, pwm_counter_1);
80004a38:	4585                	li	a1,1
80004a3a:	f0420537          	lui	a0,0xf0420
80004a3e:	3e9d                	jal	800045b4 <pwmv2_counter_burst_disable>
    pwmv2_counter_burst_disable(PWM, pwm_counter_2);
80004a40:	4589                	li	a1,2
80004a42:	f0420537          	lui	a0,0xf0420
80004a46:	36bd                	jal	800045b4 <pwmv2_counter_burst_disable>

    pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(7), reload -2, 0, false);
80004a48:	012007b7          	lui	a5,0x1200
80004a4c:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
80004a50:	17f9                	addi	a5,a5,-2
80004a52:	4701                	li	a4,0
80004a54:	4681                	li	a3,0
80004a56:	863e                	mv	a2,a5
80004a58:	459d                	li	a1,7
80004a5a:	f0420537          	lui	a0,0xf0420
80004a5e:	570030ef          	jal	80007fce <pwmv2_set_shadow_val>
    pwmv2_select_cmp_source(PWM, 16, cmp_value_from_shadow_val, PWMV2_SHADOW_INDEX(7));
80004a62:	469d                	li	a3,7
80004a64:	4601                	li	a2,0
80004a66:	45c1                	li	a1,16
80004a68:	f0420537          	lui	a0,0xf0420
80004a6c:	3ee9                	jal	80004646 <pwmv2_select_cmp_source>
    pwmv2_set_trigout_cmp_index(PWM, APP_ADC16_HW_TRGM_SRC_OUT_CH, 16);
80004a6e:	4641                	li	a2,16
80004a70:	4581                	li	a1,0
80004a72:	f0420537          	lui	a0,0xf0420
80004a76:	34a9                	jal	800044c0 <pwmv2_set_trigout_cmp_index>

    pwmv2_shadow_register_lock(PWM);
80004a78:	f0420537          	lui	a0,0xf0420
80004a7c:	53a030ef          	jal	80007fb6 <pwmv2_shadow_register_lock>

    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN1);
80004a80:	4581                	li	a1,0
80004a82:	f0420537          	lui	a0,0xf0420
80004a86:	588030ef          	jal	8000800e <pwmv2_disable_four_cmp>
    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN2);
80004a8a:	4585                	li	a1,1
80004a8c:	f0420537          	lui	a0,0xf0420
80004a90:	57e030ef          	jal	8000800e <pwmv2_disable_four_cmp>
    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN3);
80004a94:	4589                	li	a1,2
80004a96:	f0420537          	lui	a0,0xf0420
80004a9a:	574030ef          	jal	8000800e <pwmv2_disable_four_cmp>
    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN4);
80004a9e:	458d                	li	a1,3
80004aa0:	f0420537          	lui	a0,0xf0420
80004aa4:	56a030ef          	jal	8000800e <pwmv2_disable_four_cmp>
    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN5);
80004aa8:	4591                	li	a1,4
80004aaa:	f0420537          	lui	a0,0xf0420
80004aae:	560030ef          	jal	8000800e <pwmv2_disable_four_cmp>
    pwmv2_disable_four_cmp(PWM, PWM_OUTPUT_PIN6);
80004ab2:	4595                	li	a1,5
80004ab4:	f0420537          	lui	a0,0xf0420
80004ab8:	556030ef          	jal	8000800e <pwmv2_disable_four_cmp>

    //pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN1);
    //pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN2);
    //pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN3);

    pwmv2_enable_output_invert(PWM, BOARD_APP_PWM_OUT4);
80004abc:	458d                	li	a1,3
80004abe:	f0420537          	lui	a0,0xf0420
80004ac2:	5b0030ef          	jal	80008072 <pwmv2_enable_output_invert>
    pwmv2_enable_output_invert(PWM, BOARD_APP_PWM_OUT5);
80004ac6:	4591                	li	a1,4
80004ac8:	f0420537          	lui	a0,0xf0420
80004acc:	5a6030ef          	jal	80008072 <pwmv2_enable_output_invert>
    pwmv2_enable_output_invert(PWM, BOARD_APP_PWM_OUT6);
80004ad0:	4595                	li	a1,5
80004ad2:	f0420537          	lui	a0,0xf0420
80004ad6:	59c030ef          	jal	80008072 <pwmv2_enable_output_invert>
    pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN4);
80004ada:	458d                	li	a1,3
80004adc:	f0420537          	lui	a0,0xf0420
80004ae0:	3285                	jal	80004440 <pwmv2_channel_enable_output>
    pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN5);
80004ae2:	4591                	li	a1,4
80004ae4:	f0420537          	lui	a0,0xf0420
80004ae8:	3aa1                	jal	80004440 <pwmv2_channel_enable_output>
    pwmv2_channel_enable_output(PWM, PWM_OUTPUT_PIN6);
80004aea:	4595                	li	a1,5
80004aec:	f0420537          	lui	a0,0xf0420
80004af0:	3a81                	jal	80004440 <pwmv2_channel_enable_output>


    pwmv2_reset_counter(PWM, pwm_counter_0);
80004af2:	4581                	li	a1,0
80004af4:	f0420537          	lui	a0,0xf0420
80004af8:	626030ef          	jal	8000811e <pwmv2_reset_counter>
    pwmv2_reset_counter(PWM, pwm_counter_1);
80004afc:	4585                	li	a1,1
80004afe:	f0420537          	lui	a0,0xf0420
80004b02:	61c030ef          	jal	8000811e <pwmv2_reset_counter>
    pwmv2_reset_counter(PWM, pwm_counter_2);
80004b06:	4589                	li	a1,2
80004b08:	f0420537          	lui	a0,0xf0420
80004b0c:	612030ef          	jal	8000811e <pwmv2_reset_counter>
    pwmv2_enable_counter(PWM, pwm_counter_0);
80004b10:	4581                	li	a1,0
80004b12:	f0420537          	lui	a0,0xf0420
80004b16:	3619                	jal	8000461c <pwmv2_enable_counter>
    pwmv2_enable_counter(PWM, pwm_counter_1);
80004b18:	4585                	li	a1,1
80004b1a:	f0420537          	lui	a0,0xf0420
80004b1e:	3cfd                	jal	8000461c <pwmv2_enable_counter>
    pwmv2_enable_counter(PWM, pwm_counter_2);
80004b20:	4589                	li	a1,2
80004b22:	f0420537          	lui	a0,0xf0420
80004b26:	3cdd                	jal	8000461c <pwmv2_enable_counter>
    pwmv2_start_pwm_output(PWM, pwm_counter_0);
80004b28:	4581                	li	a1,0
80004b2a:	f0420537          	lui	a0,0xf0420
80004b2e:	3c75                	jal	800045ea <pwmv2_start_pwm_output>
    pwmv2_start_pwm_output(PWM, pwm_counter_1);
80004b30:	4585                	li	a1,1
80004b32:	f0420537          	lui	a0,0xf0420
80004b36:	3c55                	jal	800045ea <pwmv2_start_pwm_output>
    pwmv2_start_pwm_output(PWM, pwm_counter_2);
80004b38:	4589                	li	a1,2
80004b3a:	f0420537          	lui	a0,0xf0420
80004b3e:	3475                	jal	800045ea <pwmv2_start_pwm_output>
    //pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(3), (reload - 800) >> 1, 0, false);
    //pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(4), (reload + 800) >> 1, 0, false);
    //pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(5), (reload - 800) >> 1, 0, false);
    //pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(6), (reload + 800) >> 1, 0, false);
    //pwmv2_shadow_register_lock(PWM);
}
80004b40:	0001                	nop
80004b42:	40b2                	lw	ra,12(sp)
80004b44:	0141                	addi	sp,sp,16
80004b46:	8082                	ret

Disassembly of section .text.init_trigger_mux:

80004b48 <init_trigger_mux>:
{
    pwmv2_enable_counter(ptr, pwm_counter_0);
}

void init_trigger_mux(TRGM_Type *ptr, uint8_t input, uint8_t output)
{
80004b48:	7179                	addi	sp,sp,-48
80004b4a:	d606                	sw	ra,44(sp)
80004b4c:	c62a                	sw	a0,12(sp)
80004b4e:	87ae                	mv	a5,a1
80004b50:	8732                	mv	a4,a2
80004b52:	00f105a3          	sb	a5,11(sp)
80004b56:	87ba                	mv	a5,a4
80004b58:	00f10523          	sb	a5,10(sp)
    trgm_output_t trgm_output_cfg;

    trgm_output_cfg.invert = false;
80004b5c:	00010a23          	sb	zero,20(sp)
    trgm_output_cfg.type = trgm_output_same_as_input;
80004b60:	cc02                	sw	zero,24(sp)

    trgm_output_cfg.input  = input;
80004b62:	00b14783          	lbu	a5,11(sp)
80004b66:	00f10e23          	sb	a5,28(sp)
    trgm_output_config(ptr, output, &trgm_output_cfg);
80004b6a:	0858                	addi	a4,sp,20
80004b6c:	00a14783          	lbu	a5,10(sp)
80004b70:	863a                	mv	a2,a4
80004b72:	85be                	mv	a1,a5
80004b74:	4532                	lw	a0,12(sp)
80004b76:	38b9                	jal	800043d4 <trgm_output_config>
}
80004b78:	0001                	nop
80004b7a:	50b2                	lw	ra,44(sp)
80004b7c:	6145                	addi	sp,sp,48
80004b7e:	8082                	ret

Disassembly of section .text.init_common_config:

80004b80 <init_common_config>:
    adc16_set_pmt_config(ptr, &pmt_cfg);
    adc16_enable_pmt_queue(ptr, trig_ch);
}

hpm_stat_t init_common_config(adc16_conversion_mode_t conv_mode)
{
80004b80:	711d                	addi	sp,sp,-96
80004b82:	ce86                	sw	ra,92(sp)
80004b84:	87aa                	mv	a5,a0
80004b86:	00f107a3          	sb	a5,15(sp)
    adc16_config_t cfg;

    /* initialize an ADC instance */
    adc16_get_default_config(&cfg);
80004b8a:	081c                	addi	a5,sp,16
80004b8c:	853e                	mv	a0,a5
80004b8e:	2c1010ef          	jal	8000664e <adc16_get_default_config>

    cfg.res            = adc16_res_16_bits;
80004b92:	47d5                	li	a5,21
80004b94:	00f10823          	sb	a5,16(sp)
    cfg.conv_mode      = conv_mode;
80004b98:	00f14783          	lbu	a5,15(sp)
80004b9c:	00f108a3          	sb	a5,17(sp)
    cfg.adc_clk_div    = adc16_clock_divider_4;
80004ba0:	4791                	li	a5,4
80004ba2:	ca3e                	sw	a5,20(sp)
    cfg.sel_sync_ahb   = (APP_ADC16_CLOCK_BUS == clock_get_source(BOARD_APP_ADC16_CLK_NAME)) ? true : false;
80004ba4:	012707b7          	lui	a5,0x1270
80004ba8:	10078513          	addi	a0,a5,256 # 1270100 <__NONCACHEABLE_RAM_segment_end__+0x30100>
80004bac:	57d000ef          	jal	80005928 <clock_get_source>
80004bb0:	87aa                	mv	a5,a0
80004bb2:	17c1                	addi	a5,a5,-16
80004bb4:	0017b793          	seqz	a5,a5
80004bb8:	0ff7f793          	zext.b	a5,a5
80004bbc:	00f10d23          	sb	a5,26(sp)

    if (cfg.conv_mode == adc16_conv_mode_sequence ||
80004bc0:	01114703          	lbu	a4,17(sp)
80004bc4:	4789                	li	a5,2
80004bc6:	00f70763          	beq	a4,a5,80004bd4 <.L71>
        cfg.conv_mode == adc16_conv_mode_preemption) {
80004bca:	01114703          	lbu	a4,17(sp)
    if (cfg.conv_mode == adc16_conv_mode_sequence ||
80004bce:	478d                	li	a5,3
80004bd0:	00f71563          	bne	a4,a5,80004bda <.L72>

80004bd4 <.L71>:
        cfg.adc_ahb_en = true;
80004bd4:	4785                	li	a5,1
80004bd6:	00f10da3          	sb	a5,27(sp)

80004bda <.L72>:
    }

    /* adc16 initialization */
    if (adc16_init(BOARD_APP_ADC16_BASE, &cfg) == status_success) {
80004bda:	081c                	addi	a5,sp,16
80004bdc:	85be                	mv	a1,a5
80004bde:	f0100537          	lui	a0,0xf0100
80004be2:	679040ef          	jal	80009a5a <adc16_init>
80004be6:	87aa                	mv	a5,a0
80004be8:	e7c1                	bnez	a5,80004c70 <.L73>
80004bea:	02a00793          	li	a5,42
80004bee:	d83e                	sw	a5,48(sp)
80004bf0:	4785                	li	a5,1
80004bf2:	d63e                	sw	a5,44(sp)
80004bf4:	e40007b7          	lui	a5,0xe4000
80004bf8:	d43e                	sw	a5,40(sp)
80004bfa:	57c2                	lw	a5,48(sp)
80004bfc:	d23e                	sw	a5,36(sp)
80004bfe:	57b2                	lw	a5,44(sp)
80004c00:	d03e                	sw	a5,32(sp)

80004c02 <.LBB23>:
ATTR_ALWAYS_INLINE static inline void __plic_set_irq_priority(uint32_t base,
                                               uint32_t irq,
                                               uint32_t priority)
{
    volatile uint32_t *priority_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_PRIORITY_OFFSET + ((irq-1) << HPM_PLIC_PRIORITY_SHIFT_PER_SOURCE));
80004c02:	5792                	lw	a5,36(sp)
80004c04:	17fd                	addi	a5,a5,-1 # e3ffffff <__FLASH_segment_end__+0x63efffff>
80004c06:	00279713          	slli	a4,a5,0x2
80004c0a:	57a2                	lw	a5,40(sp)
80004c0c:	97ba                	add	a5,a5,a4
80004c0e:	0791                	addi	a5,a5,4
    volatile uint32_t *priority_ptr = (volatile uint32_t *)(base +
80004c10:	ce3e                	sw	a5,28(sp)
    *priority_ptr = priority;
80004c12:	47f2                	lw	a5,28(sp)
80004c14:	5702                	lw	a4,32(sp)
80004c16:	c398                	sw	a4,0(a5)
}
80004c18:	0001                	nop

80004c1a <.LBE25>:
 * @param[in] priority Priority of interrupt
 */
ATTR_ALWAYS_INLINE static inline void intc_set_irq_priority(uint32_t irq, uint32_t priority)
{
    __plic_set_irq_priority(HPM_PLIC_BASE, irq, priority);
}
80004c1a:	0001                	nop
80004c1c:	c682                	sw	zero,76(sp)
80004c1e:	02a00793          	li	a5,42
80004c22:	c4be                	sw	a5,72(sp)
80004c24:	e40007b7          	lui	a5,0xe4000
80004c28:	c2be                	sw	a5,68(sp)
80004c2a:	47b6                	lw	a5,76(sp)
80004c2c:	c0be                	sw	a5,64(sp)
80004c2e:	47a6                	lw	a5,72(sp)
80004c30:	de3e                	sw	a5,60(sp)

80004c32 <.LBB27>:
                                                        uint32_t target,
                                                        uint32_t irq)
{
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_ENABLE_OFFSET +
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80004c32:	4786                	lw	a5,64(sp)
80004c34:	00779713          	slli	a4,a5,0x7
            HPM_PLIC_ENABLE_OFFSET +
80004c38:	4796                	lw	a5,68(sp)
80004c3a:	973e                	add	a4,a4,a5
            ((irq >> 5) << 2));
80004c3c:	57f2                	lw	a5,60(sp)
80004c3e:	8395                	srli	a5,a5,0x5
80004c40:	078a                	slli	a5,a5,0x2
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
80004c42:	973e                	add	a4,a4,a5
80004c44:	6789                	lui	a5,0x2
80004c46:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
80004c48:	dc3e                	sw	a5,56(sp)
    uint32_t current = *current_ptr;
80004c4a:	57e2                	lw	a5,56(sp)
80004c4c:	439c                	lw	a5,0(a5)
80004c4e:	da3e                	sw	a5,52(sp)
    current = current | (1 << (irq & 0x1F));
80004c50:	57f2                	lw	a5,60(sp)
80004c52:	8bfd                	andi	a5,a5,31
80004c54:	4705                	li	a4,1
80004c56:	00f717b3          	sll	a5,a4,a5
80004c5a:	873e                	mv	a4,a5
80004c5c:	57d2                	lw	a5,52(sp)
80004c5e:	8fd9                	or	a5,a5,a4
80004c60:	da3e                	sw	a5,52(sp)
    *current_ptr = current;
80004c62:	57e2                	lw	a5,56(sp)
80004c64:	5752                	lw	a4,52(sp)
80004c66:	c398                	sw	a4,0(a5)
}
80004c68:	0001                	nop

80004c6a <.LBE29>:
}
80004c6a:	0001                	nop

80004c6c <.LBE27>:
        /* enable irq */
        intc_m_enable_irq_with_priority(BOARD_APP_ADC16_IRQn, 1);
        return status_success;
80004c6c:	4781                	li	a5,0
80004c6e:	a821                	j	80004c86 <.L75>

80004c70 <.L73>:
    } else {
        printf("%s initialization failed!\n", BOARD_APP_ADC16_NAME);
80004c70:	800047b7          	lui	a5,0x80004
80004c74:	90c78593          	addi	a1,a5,-1780 # 8000390c <.LC3>
80004c78:	800047b7          	lui	a5,0x80004
80004c7c:	91478513          	addi	a0,a5,-1772 # 80003914 <.LC4>
80004c80:	48a020ef          	jal	8000710a <printf>
        return status_fail;
80004c84:	4785                	li	a5,1

80004c86 <.L75>:
    }
}
80004c86:	853e                	mv	a0,a5
80004c88:	40f6                	lw	ra,92(sp)
80004c8a:	6125                	addi	sp,sp,96
80004c8c:	8082                	ret

Disassembly of section .text.init_preemption_config:

80004c8e <init_preemption_config>:

void init_preemption_config(void)
{
80004c8e:	1101                	addi	sp,sp,-32
80004c90:	ce06                	sw	ra,28(sp)
    adc16_channel_config_t ch_cfg;

    /* get a default channel config */
    adc16_get_channel_default_config(&ch_cfg);
80004c92:	878a                	mv	a5,sp
80004c94:	853e                	mv	a0,a5
80004c96:	24d040ef          	jal	800096e2 <adc16_get_channel_default_config>

    /* initialize an ADC channel */
    ch_cfg.sample_cycle = APP_ADC16_CH_SAMPLE_CYCLE;
80004c9a:	47d1                	li	a5,20
80004c9c:	c43e                	sw	a5,8(sp)

80004c9e <.LBB31>:

    for (uint32_t i = 0; i < sizeof(trig_adc_channel); i++) {
80004c9e:	c602                	sw	zero,12(sp)
80004ca0:	a025                	j	80004cc8 <.L77>

80004ca2 <.L78>:
        ch_cfg.ch = trig_adc_channel[i];
80004ca2:	012007b7          	lui	a5,0x1200
80004ca6:	05c78713          	addi	a4,a5,92 # 120005c <trig_adc_channel>
80004caa:	47b2                	lw	a5,12(sp)
80004cac:	97ba                	add	a5,a5,a4
80004cae:	0007c783          	lbu	a5,0(a5)
80004cb2:	00f10023          	sb	a5,0(sp)
        adc16_init_channel(BOARD_APP_ADC16_BASE, &ch_cfg);
80004cb6:	878a                	mv	a5,sp
80004cb8:	85be                	mv	a1,a5
80004cba:	f0100537          	lui	a0,0xf0100
80004cbe:	6e3040ef          	jal	80009ba0 <adc16_init_channel>
    for (uint32_t i = 0; i < sizeof(trig_adc_channel); i++) {
80004cc2:	47b2                	lw	a5,12(sp)
80004cc4:	0785                	addi	a5,a5,1
80004cc6:	c63e                	sw	a5,12(sp)

80004cc8 <.L77>:
80004cc8:	4732                	lw	a4,12(sp)
80004cca:	4789                	li	a5,2
80004ccc:	fce7fbe3          	bgeu	a5,a4,80004ca2 <.L78>

80004cd0 <.LBE31>:
    }

    /* Trigger target initialization */
    init_trigger_target(BOARD_APP_ADC16_BASE, APP_ADC16_PMT_TRIG_CH);
80004cd0:	4581                	li	a1,0
80004cd2:	f0100537          	lui	a0,0xf0100
80004cd6:	5d8030ef          	jal	800082ae <init_trigger_target>

    /* Set DMA start address for preemption mode */
    adc16_init_pmt_dma(BOARD_APP_ADC16_BASE, core_local_mem_to_sys_address(APP_ADC16_CORE, (uint32_t)pmt_buff));
80004cda:	012317b7          	lui	a5,0x1231
80004cde:	00078793          	mv	a5,a5
80004ce2:	85be                	mv	a1,a5
80004ce4:	4501                	li	a0,0
80004ce6:	a20ff0ef          	jal	80003f06 <core_local_mem_to_sys_address>
80004cea:	87aa                	mv	a5,a0
80004cec:	85be                	mv	a1,a5
80004cee:	f0100537          	lui	a0,0xf0100
80004cf2:	3a4d                	jal	800046a4 <adc16_init_pmt_dma>

    /* Enable trigger complete interrupt */
    adc16_enable_interrupts(BOARD_APP_ADC16_BASE, APP_ADC16_PMT_IRQ_EVENT);
80004cf4:	800005b7          	lui	a1,0x80000
80004cf8:	f0100537          	lui	a0,0xf0100
80004cfc:	482030ef          	jal	8000817e <adc16_enable_interrupts>

#if !defined(ADC_SOC_NO_HW_TRIG_SRC) && !defined(__ADC16_USE_SW_TRIG)
    /* Trigger mux initialization */
    init_trigger_mux(APP_ADC16_HW_TRGM, APP_ADC16_HW_TRGM_IN, APP_ADC16_HW_TRGM_OUT_PMT);
80004d00:	02200613          	li	a2,34
80004d04:	45e1                	li	a1,24
80004d06:	f047c537          	lui	a0,0xf047c
80004d0a:	3d3d                	jal	80004b48 <init_trigger_mux>

    /* Trigger source initialization */
    //init_trigger_source(APP_ADC16_HW_TRIG_SRC);
#endif
}
80004d0c:	0001                	nop
80004d0e:	40f2                	lw	ra,28(sp)
80004d10:	6105                	addi	sp,sp,32
80004d12:	8082                	ret

Disassembly of section .text.sin_f32:

80004d14 <sin_f32>:
    }
    return 0;
}

float sin_f32(float x)
{
80004d14:	7139                	addi	sp,sp,-64
80004d16:	de06                	sw	ra,60(sp)
80004d18:	dc22                	sw	s0,56(sp)
80004d1a:	c62a                	sw	a0,12(sp)
    int32_t  n;
    float    findex;

    /* input x is in radians */
    /* Scale the input to [0 1] range from [0 2*PI] , divide input by 2*pi */
    in = x * 0.159154943092f;
80004d1c:	9741a583          	lw	a1,-1676(gp) # 80003aa8 <.LC17>
80004d20:	4532                	lw	a0,12(sp)
80004d22:	2ce050ef          	jal	80009ff0 <__mulsf3>
80004d26:	87aa                	mv	a5,a0
80004d28:	d03e                	sw	a5,32(sp)

    /* Calculation of floor value of input */
    n = (int32_t) in;
80004d2a:	5502                	lw	a0,32(sp)
80004d2c:	589010ef          	jal	80006ab4 <__fixsfsi>
80004d30:	87aa                	mv	a5,a0
80004d32:	d43e                	sw	a5,40(sp)

    /* Make negative values towards -infinity */
    if (x < 0.0f) {
80004d34:	00000593          	li	a1,0
80004d38:	4532                	lw	a0,12(sp)
80004d3a:	49b010ef          	jal	800069d4 <__ltsf2>
80004d3e:	87aa                	mv	a5,a0
80004d40:	0007d563          	bgez	a5,80004d4a <.L95>
        n--;
80004d44:	57a2                	lw	a5,40(sp)
80004d46:	17fd                	addi	a5,a5,-1 # 1230fff <seq_buff+0xfff>
80004d48:	d43e                	sw	a5,40(sp)

80004d4a <.L95>:
    }

    /* Map input value to [0 1] */
    in = in - (float) n;
80004d4a:	5522                	lw	a0,40(sp)
80004d4c:	5e5010ef          	jal	80006b30 <__floatsisf>
80004d50:	87aa                	mv	a5,a0
80004d52:	85be                	mv	a1,a5
80004d54:	5502                	lw	a0,32(sp)
80004d56:	2c9010ef          	jal	8000681e <__subsf3>
80004d5a:	87aa                	mv	a5,a0
80004d5c:	d03e                	sw	a5,32(sp)

    /* Calculation of index of the table */
    findex = (float) SIN_TABLE_SIZE * in;
80004d5e:	9781a583          	lw	a1,-1672(gp) # 80003aac <.LC18>
80004d62:	5502                	lw	a0,32(sp)
80004d64:	28c050ef          	jal	80009ff0 <__mulsf3>
80004d68:	87aa                	mv	a5,a0
80004d6a:	d23e                	sw	a5,36(sp)
    index  = (uint16_t) findex;
80004d6c:	5512                	lw	a0,36(sp)
80004d6e:	591010ef          	jal	80006afe <__fixunssfsi>
80004d72:	87aa                	mv	a5,a0
80004d74:	02f11723          	sh	a5,46(sp)

    /* when "in" is exactly 1, we need to rotate the index down to 0 */
    if (index >= SIN_TABLE_SIZE) {
80004d78:	02e15703          	lhu	a4,46(sp)
80004d7c:	1ff00793          	li	a5,511
80004d80:	00e7fb63          	bgeu	a5,a4,80004d96 <.L97>
        index = 0;
80004d84:	02011723          	sh	zero,46(sp)
        findex -= (float) SIN_TABLE_SIZE;
80004d88:	9781a583          	lw	a1,-1672(gp) # 80003aac <.LC18>
80004d8c:	5512                	lw	a0,36(sp)
80004d8e:	291010ef          	jal	8000681e <__subsf3>
80004d92:	87aa                	mv	a5,a0
80004d94:	d23e                	sw	a5,36(sp)

80004d96 <.L97>:
    }

    /* fractional value calculation */
    fract = findex - (float) index;
80004d96:	02e15783          	lhu	a5,46(sp)
80004d9a:	853e                	mv	a0,a5
80004d9c:	5fb010ef          	jal	80006b96 <__floatunsisf>
80004da0:	87aa                	mv	a5,a0
80004da2:	85be                	mv	a1,a5
80004da4:	5512                	lw	a0,36(sp)
80004da6:	279010ef          	jal	8000681e <__subsf3>
80004daa:	87aa                	mv	a5,a0
80004dac:	ce3e                	sw	a5,28(sp)

    /* Read two nearest values of input value from the sin table */
    a = sinTable_f32[index];
80004dae:	02e15783          	lhu	a5,46(sp)
80004db2:	80003737          	lui	a4,0x80003
80004db6:	10870713          	addi	a4,a4,264 # 80003108 <sinTable_f32>
80004dba:	078a                	slli	a5,a5,0x2
80004dbc:	97ba                	add	a5,a5,a4
80004dbe:	439c                	lw	a5,0(a5)
80004dc0:	cc3e                	sw	a5,24(sp)
    b = sinTable_f32[index + 1];
80004dc2:	02e15783          	lhu	a5,46(sp)
80004dc6:	0785                	addi	a5,a5,1
80004dc8:	80003737          	lui	a4,0x80003
80004dcc:	10870713          	addi	a4,a4,264 # 80003108 <sinTable_f32>
80004dd0:	078a                	slli	a5,a5,0x2
80004dd2:	97ba                	add	a5,a5,a4
80004dd4:	439c                	lw	a5,0(a5)
80004dd6:	ca3e                	sw	a5,20(sp)

    /* Linear interpolation process */
    sinVal = (1.0f - fract) * a + fract * b;
80004dd8:	45f2                	lw	a1,28(sp)
80004dda:	97c1a503          	lw	a0,-1668(gp) # 80003ab0 <.LC19>
80004dde:	241010ef          	jal	8000681e <__subsf3>
80004de2:	87aa                	mv	a5,a0
80004de4:	45e2                	lw	a1,24(sp)
80004de6:	853e                	mv	a0,a5
80004de8:	208050ef          	jal	80009ff0 <__mulsf3>
80004dec:	87aa                	mv	a5,a0
80004dee:	843e                	mv	s0,a5
80004df0:	45d2                	lw	a1,20(sp)
80004df2:	4572                	lw	a0,28(sp)
80004df4:	1fc050ef          	jal	80009ff0 <__mulsf3>
80004df8:	87aa                	mv	a5,a0
80004dfa:	85be                	mv	a1,a5
80004dfc:	8522                	mv	a0,s0
80004dfe:	229010ef          	jal	80006826 <__addsf3>
80004e02:	87aa                	mv	a5,a0
80004e04:	c83e                	sw	a5,16(sp)

    /* Return the output value */
    return (sinVal);
80004e06:	47c2                	lw	a5,16(sp)
}
80004e08:	853e                	mv	a0,a5
80004e0a:	50f2                	lw	ra,60(sp)
80004e0c:	5462                	lw	s0,56(sp)
80004e0e:	6121                	addi	sp,sp,64
80004e10:	8082                	ret

Disassembly of section .text.inverse_park:

80004e12 <inverse_park>:
    /* Return the output value */
    return (cosVal);
}

void inverse_park(float mod_d, float mod_q, float Theta, float *mod_alpha, float *mod_beta)
{
80004e12:	7139                	addi	sp,sp,-64
80004e14:	de06                	sw	ra,60(sp)
80004e16:	dc22                	sw	s0,56(sp)
80004e18:	ce2a                	sw	a0,28(sp)
80004e1a:	cc2e                	sw	a1,24(sp)
80004e1c:	ca32                	sw	a2,20(sp)
80004e1e:	c836                	sw	a3,16(sp)
80004e20:	c63a                	sw	a4,12(sp)
    float s    = sin_f32(Theta);
80004e22:	4552                	lw	a0,20(sp)
80004e24:	3dc5                	jal	80004d14 <sin_f32>
80004e26:	d62a                	sw	a0,44(sp)
    float c    = cos_f32(Theta);
80004e28:	4552                	lw	a0,20(sp)
80004e2a:	6b2030ef          	jal	800084dc <cos_f32>
80004e2e:	d42a                	sw	a0,40(sp)

    *mod_alpha = mod_d * c - mod_q * s;
80004e30:	55a2                	lw	a1,40(sp)
80004e32:	4572                	lw	a0,28(sp)
80004e34:	1bc050ef          	jal	80009ff0 <__mulsf3>
80004e38:	87aa                	mv	a5,a0
80004e3a:	843e                	mv	s0,a5
80004e3c:	55b2                	lw	a1,44(sp)
80004e3e:	4562                	lw	a0,24(sp)
80004e40:	1b0050ef          	jal	80009ff0 <__mulsf3>
80004e44:	87aa                	mv	a5,a0
80004e46:	85be                	mv	a1,a5
80004e48:	8522                	mv	a0,s0
80004e4a:	1d5010ef          	jal	8000681e <__subsf3>
80004e4e:	87aa                	mv	a5,a0
80004e50:	873e                	mv	a4,a5
80004e52:	47c2                	lw	a5,16(sp)
80004e54:	c398                	sw	a4,0(a5)
    *mod_beta  = mod_d * s + mod_q * c;
80004e56:	55b2                	lw	a1,44(sp)
80004e58:	4572                	lw	a0,28(sp)
80004e5a:	196050ef          	jal	80009ff0 <__mulsf3>
80004e5e:	87aa                	mv	a5,a0
80004e60:	843e                	mv	s0,a5
80004e62:	55a2                	lw	a1,40(sp)
80004e64:	4562                	lw	a0,24(sp)
80004e66:	18a050ef          	jal	80009ff0 <__mulsf3>
80004e6a:	87aa                	mv	a5,a0
80004e6c:	85be                	mv	a1,a5
80004e6e:	8522                	mv	a0,s0
80004e70:	1b7010ef          	jal	80006826 <__addsf3>
80004e74:	87aa                	mv	a5,a0
80004e76:	873e                	mv	a4,a5
80004e78:	47b2                	lw	a5,12(sp)
80004e7a:	c398                	sw	a4,0(a5)
}
80004e7c:	0001                	nop
80004e7e:	50f2                	lw	ra,60(sp)
80004e80:	5462                	lw	s0,56(sp)
80004e82:	6121                	addi	sp,sp,64
80004e84:	8082                	ret

Disassembly of section .text.svm:

80004e86 <svm>:
/// @param alpha Input   [-1~+1]
/// @param duty_a Output [0~1]
/// @param duty_b Output [0~1]
/// @param duty_c Output [0~1]
int svm(float alpha, float beta, float *duty_a, float *duty_b, float *duty_c)
{
80004e86:	7159                	addi	sp,sp,-112
80004e88:	d686                	sw	ra,108(sp)
80004e8a:	d4a2                	sw	s0,104(sp)
80004e8c:	ce2a                	sw	a0,28(sp)
80004e8e:	cc2e                	sw	a1,24(sp)
80004e90:	ca32                	sw	a2,20(sp)
80004e92:	c836                	sw	a3,16(sp)
80004e94:	c63a                	sw	a4,12(sp)
    int Sextant;

    if (beta >= 0.0f) {
80004e96:	00000593          	li	a1,0
80004e9a:	4562                	lw	a0,24(sp)
80004e9c:	3db010ef          	jal	80006a76 <__gesf2>
80004ea0:	87aa                	mv	a5,a0
80004ea2:	0607c063          	bltz	a5,80004f02 <.L155>
        if (alpha >= 0.0f) {
80004ea6:	00000593          	li	a1,0
80004eaa:	4572                	lw	a0,28(sp)
80004eac:	3cb010ef          	jal	80006a76 <__gesf2>
80004eb0:	87aa                	mv	a5,a0
80004eb2:	0207c563          	bltz	a5,80004edc <.L156>
            //quadrant I
            if (ONE_BY_SQRT3 * beta > alpha)
80004eb6:	9841a583          	lw	a1,-1660(gp) # 80003ab8 <.LC21>
80004eba:	4562                	lw	a0,24(sp)
80004ebc:	134050ef          	jal	80009ff0 <__mulsf3>
80004ec0:	87aa                	mv	a5,a0
80004ec2:	85be                	mv	a1,a5
80004ec4:	4572                	lw	a0,28(sp)
80004ec6:	30f010ef          	jal	800069d4 <__ltsf2>
80004eca:	87aa                	mv	a5,a0
80004ecc:	0007d563          	bgez	a5,80004ed6 <.L157>
                Sextant = 2; //sextant v2-v3
80004ed0:	4789                	li	a5,2
80004ed2:	cebe                	sw	a5,92(sp)
80004ed4:	a061                	j	80004f5c <.L114>

80004ed6 <.L157>:
            else
                Sextant = 1; //sextant v1-v2
80004ed6:	4785                	li	a5,1
80004ed8:	cebe                	sw	a5,92(sp)
80004eda:	a049                	j	80004f5c <.L114>

80004edc <.L156>:

        } else {
            //quadrant II
            if (-ONE_BY_SQRT3 * beta > alpha)
80004edc:	9881a583          	lw	a1,-1656(gp) # 80003abc <.LC22>
80004ee0:	4562                	lw	a0,24(sp)
80004ee2:	10e050ef          	jal	80009ff0 <__mulsf3>
80004ee6:	87aa                	mv	a5,a0
80004ee8:	85be                	mv	a1,a5
80004eea:	4572                	lw	a0,28(sp)
80004eec:	2e9010ef          	jal	800069d4 <__ltsf2>
80004ef0:	87aa                	mv	a5,a0
80004ef2:	0007d563          	bgez	a5,80004efc <.L158>
                Sextant = 3; //sextant v3-v4
80004ef6:	478d                	li	a5,3
80004ef8:	cebe                	sw	a5,92(sp)
80004efa:	a08d                	j	80004f5c <.L114>

80004efc <.L158>:
            else
                Sextant = 2; //sextant v2-v3
80004efc:	4789                	li	a5,2
80004efe:	cebe                	sw	a5,92(sp)
80004f00:	a8b1                	j	80004f5c <.L114>

80004f02 <.L155>:
        }
    } else {
        if (alpha >= 0.0f) {
80004f02:	00000593          	li	a1,0
80004f06:	4572                	lw	a0,28(sp)
80004f08:	36f010ef          	jal	80006a76 <__gesf2>
80004f0c:	87aa                	mv	a5,a0
80004f0e:	0207c563          	bltz	a5,80004f38 <.L159>
            //quadrant IV
            if (-ONE_BY_SQRT3 * beta > alpha)
80004f12:	9881a583          	lw	a1,-1656(gp) # 80003abc <.LC22>
80004f16:	4562                	lw	a0,24(sp)
80004f18:	0d8050ef          	jal	80009ff0 <__mulsf3>
80004f1c:	87aa                	mv	a5,a0
80004f1e:	85be                	mv	a1,a5
80004f20:	4572                	lw	a0,28(sp)
80004f22:	2b3010ef          	jal	800069d4 <__ltsf2>
80004f26:	87aa                	mv	a5,a0
80004f28:	0007d563          	bgez	a5,80004f32 <.L160>
                Sextant = 5; //sextant v5-v6
80004f2c:	4795                	li	a5,5
80004f2e:	cebe                	sw	a5,92(sp)
80004f30:	a035                	j	80004f5c <.L114>

80004f32 <.L160>:
            else
                Sextant = 6; //sextant v6-v1
80004f32:	4799                	li	a5,6
80004f34:	cebe                	sw	a5,92(sp)
80004f36:	a01d                	j	80004f5c <.L114>

80004f38 <.L159>:
        } else {
            //quadrant III
            if (ONE_BY_SQRT3 * beta > alpha)
80004f38:	9841a583          	lw	a1,-1660(gp) # 80003ab8 <.LC21>
80004f3c:	4562                	lw	a0,24(sp)
80004f3e:	0b2050ef          	jal	80009ff0 <__mulsf3>
80004f42:	87aa                	mv	a5,a0
80004f44:	85be                	mv	a1,a5
80004f46:	4572                	lw	a0,28(sp)
80004f48:	28d010ef          	jal	800069d4 <__ltsf2>
80004f4c:	87aa                	mv	a5,a0
80004f4e:	0007d563          	bgez	a5,80004f58 <.L161>
                Sextant = 4; //sextant v4-v5
80004f52:	4791                	li	a5,4
80004f54:	cebe                	sw	a5,92(sp)
80004f56:	a019                	j	80004f5c <.L114>

80004f58 <.L161>:
            else
                Sextant = 5; //sextant v5-v6
80004f58:	4795                	li	a5,5
80004f5a:	cebe                	sw	a5,92(sp)

80004f5c <.L114>:
        }
    }

    switch (Sextant) {
80004f5c:	4776                	lw	a4,92(sp)
80004f5e:	4799                	li	a5,6
80004f60:	30e7ec63          	bltu	a5,a4,80005278 <.L123>
80004f64:	47f6                	lw	a5,92(sp)
80004f66:	00279713          	slli	a4,a5,0x2
80004f6a:	9a018793          	addi	a5,gp,-1632 # 80003ad4 <.L125>
80004f6e:	97ba                	add	a5,a5,a4
80004f70:	439c                	lw	a5,0(a5)
80004f72:	8782                	jr	a5

80004f74 <.L130>:
    // sextant v1-v2
    case 1: {
        // Vector on-times
        float t1 = alpha - ONE_BY_SQRT3 * beta;
80004f74:	9841a583          	lw	a1,-1660(gp) # 80003ab8 <.LC21>
80004f78:	4562                	lw	a0,24(sp)
80004f7a:	076050ef          	jal	80009ff0 <__mulsf3>
80004f7e:	87aa                	mv	a5,a0
80004f80:	85be                	mv	a1,a5
80004f82:	4572                	lw	a0,28(sp)
80004f84:	09b010ef          	jal	8000681e <__subsf3>
80004f88:	87aa                	mv	a5,a0
80004f8a:	d83e                	sw	a5,48(sp)
        float t2 = TWO_BY_SQRT3 * beta;
80004f8c:	98c1a583          	lw	a1,-1652(gp) # 80003ac0 <.LC23>
80004f90:	4562                	lw	a0,24(sp)
80004f92:	05e050ef          	jal	80009ff0 <__mulsf3>
80004f96:	87aa                	mv	a5,a0
80004f98:	d63e                	sw	a5,44(sp)

        // PWM timings
        *duty_a = (1.0f - t1 - t2) * 0.5f;
80004f9a:	55c2                	lw	a1,48(sp)
80004f9c:	97c1a503          	lw	a0,-1668(gp) # 80003ab0 <.LC19>
80004fa0:	07f010ef          	jal	8000681e <__subsf3>
80004fa4:	87aa                	mv	a5,a0
80004fa6:	55b2                	lw	a1,44(sp)
80004fa8:	853e                	mv	a0,a5
80004faa:	075010ef          	jal	8000681e <__subsf3>
80004fae:	87aa                	mv	a5,a0
80004fb0:	873e                	mv	a4,a5
80004fb2:	9701a583          	lw	a1,-1680(gp) # 80003aa4 <.LC2>
80004fb6:	853a                	mv	a0,a4
80004fb8:	038050ef          	jal	80009ff0 <__mulsf3>
80004fbc:	87aa                	mv	a5,a0
80004fbe:	873e                	mv	a4,a5
80004fc0:	47d2                	lw	a5,20(sp)
80004fc2:	c398                	sw	a4,0(a5)
        *duty_b = *duty_a + t1;
80004fc4:	47d2                	lw	a5,20(sp)
80004fc6:	439c                	lw	a5,0(a5)
80004fc8:	55c2                	lw	a1,48(sp)
80004fca:	853e                	mv	a0,a5
80004fcc:	05b010ef          	jal	80006826 <__addsf3>
80004fd0:	87aa                	mv	a5,a0
80004fd2:	873e                	mv	a4,a5
80004fd4:	47c2                	lw	a5,16(sp)
80004fd6:	c398                	sw	a4,0(a5)
        *duty_c = *duty_b + t2;
80004fd8:	47c2                	lw	a5,16(sp)
80004fda:	439c                	lw	a5,0(a5)
80004fdc:	55b2                	lw	a1,44(sp)
80004fde:	853e                	mv	a0,a5
80004fe0:	047010ef          	jal	80006826 <__addsf3>
80004fe4:	87aa                	mv	a5,a0
80004fe6:	873e                	mv	a4,a5
80004fe8:	47b2                	lw	a5,12(sp)
80004fea:	c398                	sw	a4,0(a5)

80004fec <.LBE42>:
    } break;
80004fec:	a471                	j	80005278 <.L123>

80004fee <.L129>:

    // sextant v2-v3
    case 2: {
        // Vector on-times
        float t2 = alpha + ONE_BY_SQRT3 * beta;
80004fee:	9841a583          	lw	a1,-1660(gp) # 80003ab8 <.LC21>
80004ff2:	4562                	lw	a0,24(sp)
80004ff4:	7fd040ef          	jal	80009ff0 <__mulsf3>
80004ff8:	87aa                	mv	a5,a0
80004ffa:	85be                	mv	a1,a5
80004ffc:	4572                	lw	a0,28(sp)
80004ffe:	029010ef          	jal	80006826 <__addsf3>
80005002:	87aa                	mv	a5,a0
80005004:	dc3e                	sw	a5,56(sp)
        float t3 = -alpha + ONE_BY_SQRT3 * beta;
80005006:	9841a583          	lw	a1,-1660(gp) # 80003ab8 <.LC21>
8000500a:	4562                	lw	a0,24(sp)
8000500c:	7e5040ef          	jal	80009ff0 <__mulsf3>
80005010:	87aa                	mv	a5,a0
80005012:	45f2                	lw	a1,28(sp)
80005014:	853e                	mv	a0,a5
80005016:	009010ef          	jal	8000681e <__subsf3>
8000501a:	87aa                	mv	a5,a0
8000501c:	da3e                	sw	a5,52(sp)

        // PWM timings
        *duty_b = (1.0f - t2 - t3) * 0.5f;
8000501e:	55e2                	lw	a1,56(sp)
80005020:	97c1a503          	lw	a0,-1668(gp) # 80003ab0 <.LC19>
80005024:	7fa010ef          	jal	8000681e <__subsf3>
80005028:	87aa                	mv	a5,a0
8000502a:	55d2                	lw	a1,52(sp)
8000502c:	853e                	mv	a0,a5
8000502e:	7f0010ef          	jal	8000681e <__subsf3>
80005032:	87aa                	mv	a5,a0
80005034:	873e                	mv	a4,a5
80005036:	9701a583          	lw	a1,-1680(gp) # 80003aa4 <.LC2>
8000503a:	853a                	mv	a0,a4
8000503c:	7b5040ef          	jal	80009ff0 <__mulsf3>
80005040:	87aa                	mv	a5,a0
80005042:	873e                	mv	a4,a5
80005044:	47c2                	lw	a5,16(sp)
80005046:	c398                	sw	a4,0(a5)
        *duty_a = *duty_b + t3;
80005048:	47c2                	lw	a5,16(sp)
8000504a:	439c                	lw	a5,0(a5)
8000504c:	55d2                	lw	a1,52(sp)
8000504e:	853e                	mv	a0,a5
80005050:	7d6010ef          	jal	80006826 <__addsf3>
80005054:	87aa                	mv	a5,a0
80005056:	873e                	mv	a4,a5
80005058:	47d2                	lw	a5,20(sp)
8000505a:	c398                	sw	a4,0(a5)
        *duty_c = *duty_a + t2;
8000505c:	47d2                	lw	a5,20(sp)
8000505e:	439c                	lw	a5,0(a5)
80005060:	55e2                	lw	a1,56(sp)
80005062:	853e                	mv	a0,a5
80005064:	7c2010ef          	jal	80006826 <__addsf3>
80005068:	87aa                	mv	a5,a0
8000506a:	873e                	mv	a4,a5
8000506c:	47b2                	lw	a5,12(sp)
8000506e:	c398                	sw	a4,0(a5)

80005070 <.LBE43>:
    } break;
80005070:	a421                	j	80005278 <.L123>

80005072 <.L128>:

    // sextant v3-v4
    case 3: {
        // Vector on-times
        float t3 = TWO_BY_SQRT3 * beta;
80005072:	98c1a583          	lw	a1,-1652(gp) # 80003ac0 <.LC23>
80005076:	4562                	lw	a0,24(sp)
80005078:	779040ef          	jal	80009ff0 <__mulsf3>
8000507c:	87aa                	mv	a5,a0
8000507e:	c0be                	sw	a5,64(sp)
        float t4 = -alpha - ONE_BY_SQRT3 * beta;
80005080:	4772                	lw	a4,28(sp)
80005082:	800007b7          	lui	a5,0x80000
80005086:	00f74433          	xor	s0,a4,a5
8000508a:	9841a583          	lw	a1,-1660(gp) # 80003ab8 <.LC21>
8000508e:	4562                	lw	a0,24(sp)
80005090:	761040ef          	jal	80009ff0 <__mulsf3>
80005094:	87aa                	mv	a5,a0
80005096:	85be                	mv	a1,a5
80005098:	8522                	mv	a0,s0
8000509a:	784010ef          	jal	8000681e <__subsf3>
8000509e:	87aa                	mv	a5,a0
800050a0:	de3e                	sw	a5,60(sp)

        // PWM timings
        *duty_b = (1.0f - t3 - t4) * 0.5f;
800050a2:	4586                	lw	a1,64(sp)
800050a4:	97c1a503          	lw	a0,-1668(gp) # 80003ab0 <.LC19>
800050a8:	776010ef          	jal	8000681e <__subsf3>
800050ac:	87aa                	mv	a5,a0
800050ae:	55f2                	lw	a1,60(sp)
800050b0:	853e                	mv	a0,a5
800050b2:	76c010ef          	jal	8000681e <__subsf3>
800050b6:	87aa                	mv	a5,a0
800050b8:	873e                	mv	a4,a5
800050ba:	9701a583          	lw	a1,-1680(gp) # 80003aa4 <.LC2>
800050be:	853a                	mv	a0,a4
800050c0:	731040ef          	jal	80009ff0 <__mulsf3>
800050c4:	87aa                	mv	a5,a0
800050c6:	873e                	mv	a4,a5
800050c8:	47c2                	lw	a5,16(sp)
800050ca:	c398                	sw	a4,0(a5)
        *duty_c = *duty_b + t3;
800050cc:	47c2                	lw	a5,16(sp)
800050ce:	439c                	lw	a5,0(a5)
800050d0:	4586                	lw	a1,64(sp)
800050d2:	853e                	mv	a0,a5
800050d4:	752010ef          	jal	80006826 <__addsf3>
800050d8:	87aa                	mv	a5,a0
800050da:	873e                	mv	a4,a5
800050dc:	47b2                	lw	a5,12(sp)
800050de:	c398                	sw	a4,0(a5)
        *duty_a = *duty_c + t4;
800050e0:	47b2                	lw	a5,12(sp)
800050e2:	439c                	lw	a5,0(a5)
800050e4:	55f2                	lw	a1,60(sp)
800050e6:	853e                	mv	a0,a5
800050e8:	73e010ef          	jal	80006826 <__addsf3>
800050ec:	87aa                	mv	a5,a0
800050ee:	873e                	mv	a4,a5
800050f0:	47d2                	lw	a5,20(sp)
800050f2:	c398                	sw	a4,0(a5)

800050f4 <.LBE44>:
    } break;
800050f4:	a251                	j	80005278 <.L123>

800050f6 <.L127>:

    // sextant v4-v5
    case 4: {
        // Vector on-times
        float t4 = -alpha + ONE_BY_SQRT3 * beta;
800050f6:	9841a583          	lw	a1,-1660(gp) # 80003ab8 <.LC21>
800050fa:	4562                	lw	a0,24(sp)
800050fc:	6f5040ef          	jal	80009ff0 <__mulsf3>
80005100:	87aa                	mv	a5,a0
80005102:	45f2                	lw	a1,28(sp)
80005104:	853e                	mv	a0,a5
80005106:	718010ef          	jal	8000681e <__subsf3>
8000510a:	87aa                	mv	a5,a0
8000510c:	c4be                	sw	a5,72(sp)
        float t5 = -TWO_BY_SQRT3 * beta;
8000510e:	9901a583          	lw	a1,-1648(gp) # 80003ac4 <.LC24>
80005112:	4562                	lw	a0,24(sp)
80005114:	6dd040ef          	jal	80009ff0 <__mulsf3>
80005118:	87aa                	mv	a5,a0
8000511a:	c2be                	sw	a5,68(sp)

        // PWM timings
        *duty_c = (1.0f - t4 - t5) * 0.5f;
8000511c:	45a6                	lw	a1,72(sp)
8000511e:	97c1a503          	lw	a0,-1668(gp) # 80003ab0 <.LC19>
80005122:	6fc010ef          	jal	8000681e <__subsf3>
80005126:	87aa                	mv	a5,a0
80005128:	4596                	lw	a1,68(sp)
8000512a:	853e                	mv	a0,a5
8000512c:	6f2010ef          	jal	8000681e <__subsf3>
80005130:	87aa                	mv	a5,a0
80005132:	873e                	mv	a4,a5
80005134:	9701a583          	lw	a1,-1680(gp) # 80003aa4 <.LC2>
80005138:	853a                	mv	a0,a4
8000513a:	6b7040ef          	jal	80009ff0 <__mulsf3>
8000513e:	87aa                	mv	a5,a0
80005140:	873e                	mv	a4,a5
80005142:	47b2                	lw	a5,12(sp)
80005144:	c398                	sw	a4,0(a5)
        *duty_b = *duty_c + t5;
80005146:	47b2                	lw	a5,12(sp)
80005148:	439c                	lw	a5,0(a5)
8000514a:	4596                	lw	a1,68(sp)
8000514c:	853e                	mv	a0,a5
8000514e:	6d8010ef          	jal	80006826 <__addsf3>
80005152:	87aa                	mv	a5,a0
80005154:	873e                	mv	a4,a5
80005156:	47c2                	lw	a5,16(sp)
80005158:	c398                	sw	a4,0(a5)
        *duty_a = *duty_b + t4;
8000515a:	47c2                	lw	a5,16(sp)
8000515c:	439c                	lw	a5,0(a5)
8000515e:	45a6                	lw	a1,72(sp)
80005160:	853e                	mv	a0,a5
80005162:	6c4010ef          	jal	80006826 <__addsf3>
80005166:	87aa                	mv	a5,a0
80005168:	873e                	mv	a4,a5
8000516a:	47d2                	lw	a5,20(sp)
8000516c:	c398                	sw	a4,0(a5)

8000516e <.LBE45>:
    } break;
8000516e:	a229                	j	80005278 <.L123>

80005170 <.L126>:

    // sextant v5-v6
    case 5: {
        // Vector on-times
        float t5 = -alpha - ONE_BY_SQRT3 * beta;
80005170:	4772                	lw	a4,28(sp)
80005172:	800007b7          	lui	a5,0x80000
80005176:	00f74433          	xor	s0,a4,a5
8000517a:	9841a583          	lw	a1,-1660(gp) # 80003ab8 <.LC21>
8000517e:	4562                	lw	a0,24(sp)
80005180:	671040ef          	jal	80009ff0 <__mulsf3>
80005184:	87aa                	mv	a5,a0
80005186:	85be                	mv	a1,a5
80005188:	8522                	mv	a0,s0
8000518a:	694010ef          	jal	8000681e <__subsf3>
8000518e:	87aa                	mv	a5,a0
80005190:	c8be                	sw	a5,80(sp)
        float t6 = alpha - ONE_BY_SQRT3 * beta;
80005192:	9841a583          	lw	a1,-1660(gp) # 80003ab8 <.LC21>
80005196:	4562                	lw	a0,24(sp)
80005198:	659040ef          	jal	80009ff0 <__mulsf3>
8000519c:	87aa                	mv	a5,a0
8000519e:	85be                	mv	a1,a5
800051a0:	4572                	lw	a0,28(sp)
800051a2:	67c010ef          	jal	8000681e <__subsf3>
800051a6:	87aa                	mv	a5,a0
800051a8:	c6be                	sw	a5,76(sp)

        // PWM timings
        *duty_c = (1.0f - t5 - t6) * 0.5f;
800051aa:	45c6                	lw	a1,80(sp)
800051ac:	97c1a503          	lw	a0,-1668(gp) # 80003ab0 <.LC19>
800051b0:	66e010ef          	jal	8000681e <__subsf3>
800051b4:	87aa                	mv	a5,a0
800051b6:	45b6                	lw	a1,76(sp)
800051b8:	853e                	mv	a0,a5
800051ba:	664010ef          	jal	8000681e <__subsf3>
800051be:	87aa                	mv	a5,a0
800051c0:	873e                	mv	a4,a5
800051c2:	9701a583          	lw	a1,-1680(gp) # 80003aa4 <.LC2>
800051c6:	853a                	mv	a0,a4
800051c8:	629040ef          	jal	80009ff0 <__mulsf3>
800051cc:	87aa                	mv	a5,a0
800051ce:	873e                	mv	a4,a5
800051d0:	47b2                	lw	a5,12(sp)
800051d2:	c398                	sw	a4,0(a5)
        *duty_a = *duty_c + t5;
800051d4:	47b2                	lw	a5,12(sp)
800051d6:	439c                	lw	a5,0(a5)
800051d8:	45c6                	lw	a1,80(sp)
800051da:	853e                	mv	a0,a5
800051dc:	64a010ef          	jal	80006826 <__addsf3>
800051e0:	87aa                	mv	a5,a0
800051e2:	873e                	mv	a4,a5
800051e4:	47d2                	lw	a5,20(sp)
800051e6:	c398                	sw	a4,0(a5)
        *duty_b = *duty_a + t6;
800051e8:	47d2                	lw	a5,20(sp)
800051ea:	439c                	lw	a5,0(a5)
800051ec:	45b6                	lw	a1,76(sp)
800051ee:	853e                	mv	a0,a5
800051f0:	636010ef          	jal	80006826 <__addsf3>
800051f4:	87aa                	mv	a5,a0
800051f6:	873e                	mv	a4,a5
800051f8:	47c2                	lw	a5,16(sp)
800051fa:	c398                	sw	a4,0(a5)

800051fc <.LBE46>:
    } break;
800051fc:	a8b5                	j	80005278 <.L123>

800051fe <.L124>:

    // sextant v6-v1
    case 6: {
        // Vector on-times
        float t6 = -TWO_BY_SQRT3 * beta;
800051fe:	9901a583          	lw	a1,-1648(gp) # 80003ac4 <.LC24>
80005202:	4562                	lw	a0,24(sp)
80005204:	5ed040ef          	jal	80009ff0 <__mulsf3>
80005208:	87aa                	mv	a5,a0
8000520a:	ccbe                	sw	a5,88(sp)
        float t1 = alpha + ONE_BY_SQRT3 * beta;
8000520c:	9841a583          	lw	a1,-1660(gp) # 80003ab8 <.LC21>
80005210:	4562                	lw	a0,24(sp)
80005212:	5df040ef          	jal	80009ff0 <__mulsf3>
80005216:	87aa                	mv	a5,a0
80005218:	85be                	mv	a1,a5
8000521a:	4572                	lw	a0,28(sp)
8000521c:	60a010ef          	jal	80006826 <__addsf3>
80005220:	87aa                	mv	a5,a0
80005222:	cabe                	sw	a5,84(sp)

        // PWM timings
        *duty_a = (1.0f - t6 - t1) * 0.5f;
80005224:	45e6                	lw	a1,88(sp)
80005226:	97c1a503          	lw	a0,-1668(gp) # 80003ab0 <.LC19>
8000522a:	5f4010ef          	jal	8000681e <__subsf3>
8000522e:	87aa                	mv	a5,a0
80005230:	45d6                	lw	a1,84(sp)
80005232:	853e                	mv	a0,a5
80005234:	5ea010ef          	jal	8000681e <__subsf3>
80005238:	87aa                	mv	a5,a0
8000523a:	873e                	mv	a4,a5
8000523c:	9701a583          	lw	a1,-1680(gp) # 80003aa4 <.LC2>
80005240:	853a                	mv	a0,a4
80005242:	5af040ef          	jal	80009ff0 <__mulsf3>
80005246:	87aa                	mv	a5,a0
80005248:	873e                	mv	a4,a5
8000524a:	47d2                	lw	a5,20(sp)
8000524c:	c398                	sw	a4,0(a5)
        *duty_c = *duty_a + t1;
8000524e:	47d2                	lw	a5,20(sp)
80005250:	439c                	lw	a5,0(a5)
80005252:	45d6                	lw	a1,84(sp)
80005254:	853e                	mv	a0,a5
80005256:	5d0010ef          	jal	80006826 <__addsf3>
8000525a:	87aa                	mv	a5,a0
8000525c:	873e                	mv	a4,a5
8000525e:	47b2                	lw	a5,12(sp)
80005260:	c398                	sw	a4,0(a5)
        *duty_b = *duty_c + t6;
80005262:	47b2                	lw	a5,12(sp)
80005264:	439c                	lw	a5,0(a5)
80005266:	45e6                	lw	a1,88(sp)
80005268:	853e                	mv	a0,a5
8000526a:	5bc010ef          	jal	80006826 <__addsf3>
8000526e:	87aa                	mv	a5,a0
80005270:	873e                	mv	a4,a5
80005272:	47c2                	lw	a5,16(sp)
80005274:	c398                	sw	a4,0(a5)

80005276 <.LBE47>:
    } break;
80005276:	0001                	nop

80005278 <.L123>:
    }

    // if any of the results becomes NaN, result_valid will evaluate to false
    int result_valid = *duty_a >= 0.0f && *duty_a <= 1.0f && *duty_b >= 0.0f && *duty_b <= 1.0f && *duty_c >= 0.0f
80005278:	47d2                	lw	a5,20(sp)
8000527a:	439c                	lw	a5,0(a5)
                       && *duty_c <= 1.0f;
8000527c:	00000593          	li	a1,0
80005280:	853e                	mv	a0,a5
80005282:	7f4010ef          	jal	80006a76 <__gesf2>
80005286:	87aa                	mv	a5,a0
80005288:	0607c663          	bltz	a5,800052f4 <.L131>
    int result_valid = *duty_a >= 0.0f && *duty_a <= 1.0f && *duty_b >= 0.0f && *duty_b <= 1.0f && *duty_c >= 0.0f
8000528c:	47d2                	lw	a5,20(sp)
8000528e:	4398                	lw	a4,0(a5)
80005290:	97c1a583          	lw	a1,-1668(gp) # 80003ab0 <.LC19>
80005294:	853a                	mv	a0,a4
80005296:	778010ef          	jal	80006a0e <__lesf2>
8000529a:	87aa                	mv	a5,a0
8000529c:	04f04c63          	bgtz	a5,800052f4 <.L131>
800052a0:	47c2                	lw	a5,16(sp)
800052a2:	439c                	lw	a5,0(a5)
800052a4:	00000593          	li	a1,0
800052a8:	853e                	mv	a0,a5
800052aa:	7cc010ef          	jal	80006a76 <__gesf2>
800052ae:	87aa                	mv	a5,a0
800052b0:	0407c263          	bltz	a5,800052f4 <.L131>
800052b4:	47c2                	lw	a5,16(sp)
800052b6:	4398                	lw	a4,0(a5)
800052b8:	97c1a583          	lw	a1,-1668(gp) # 80003ab0 <.LC19>
800052bc:	853a                	mv	a0,a4
800052be:	750010ef          	jal	80006a0e <__lesf2>
800052c2:	87aa                	mv	a5,a0
800052c4:	02f04863          	bgtz	a5,800052f4 <.L131>
800052c8:	47b2                	lw	a5,12(sp)
800052ca:	439c                	lw	a5,0(a5)
800052cc:	00000593          	li	a1,0
800052d0:	853e                	mv	a0,a5
800052d2:	7a4010ef          	jal	80006a76 <__gesf2>
800052d6:	87aa                	mv	a5,a0
800052d8:	0007ce63          	bltz	a5,800052f4 <.L131>
                       && *duty_c <= 1.0f;
800052dc:	47b2                	lw	a5,12(sp)
800052de:	4398                	lw	a4,0(a5)
800052e0:	97c1a583          	lw	a1,-1668(gp) # 80003ab0 <.LC19>
800052e4:	853a                	mv	a0,a4
800052e6:	728010ef          	jal	80006a0e <__lesf2>
800052ea:	87aa                	mv	a5,a0
800052ec:	00f04463          	bgtz	a5,800052f4 <.L131>
800052f0:	4785                	li	a5,1
800052f2:	a011                	j	800052f6 <.L138>

800052f4 <.L131>:
800052f4:	4781                	li	a5,0

800052f6 <.L138>:
    int result_valid = *duty_a >= 0.0f && *duty_a <= 1.0f && *duty_b >= 0.0f && *duty_b <= 1.0f && *duty_c >= 0.0f
800052f6:	d43e                	sw	a5,40(sp)

    return result_valid ? 0 : -1;
800052f8:	57a2                	lw	a5,40(sp)
800052fa:	c399                	beqz	a5,80005300 <.L139>
800052fc:	4781                	li	a5,0
800052fe:	a011                	j	80005302 <.L141>

80005300 <.L139>:
80005300:	57fd                	li	a5,-1

80005302 <.L141>:
}
80005302:	853e                	mv	a0,a5
80005304:	50b6                	lw	ra,108(sp)
80005306:	5426                	lw	s0,104(sp)
80005308:	6165                	addi	sp,sp,112
8000530a:	8082                	ret

Disassembly of section .text.FOC_voltage:

8000530c <FOC_voltage>:

void FOC_voltage(float Vd_set, float Vq_set, float phase)
{
8000530c:	715d                	addi	sp,sp,-80
8000530e:	c686                	sw	ra,76(sp)
80005310:	c4a2                	sw	s0,72(sp)
80005312:	c62a                	sw	a0,12(sp)
80005314:	c42e                	sw	a1,8(sp)
80005316:	c232                	sw	a2,4(sp)
    float v_to_mod = 1.5f / 12.0f; // = 1.0f / (Foc.v_bus_filt * 2.0f / 3.0f);
80005318:	9941a783          	lw	a5,-1644(gp) # 80003ac8 <.LC25>
8000531c:	da3e                	sw	a5,52(sp)
    float mod_vd   = Vd_set * v_to_mod;
8000531e:	55d2                	lw	a1,52(sp)
80005320:	4532                	lw	a0,12(sp)
80005322:	4cf040ef          	jal	80009ff0 <__mulsf3>
80005326:	87aa                	mv	a5,a0
80005328:	de3e                	sw	a5,60(sp)
    float mod_vq   = Vq_set * v_to_mod;
8000532a:	55d2                	lw	a1,52(sp)
8000532c:	4522                	lw	a0,8(sp)
8000532e:	4c3040ef          	jal	80009ff0 <__mulsf3>
80005332:	87aa                	mv	a5,a0
80005334:	dc3e                	sw	a5,56(sp)

    // Vector modulation saturation, lock integrator if saturated
    float factor = 0.9f * SQRT3_BY_2 / sqrtf(SQ(mod_vd) + SQ(mod_vq));
80005336:	55f2                	lw	a1,60(sp)
80005338:	5572                	lw	a0,60(sp)
8000533a:	4b7040ef          	jal	80009ff0 <__mulsf3>
8000533e:	87aa                	mv	a5,a0
80005340:	843e                	mv	s0,a5
80005342:	55e2                	lw	a1,56(sp)
80005344:	5562                	lw	a0,56(sp)
80005346:	4ab040ef          	jal	80009ff0 <__mulsf3>
8000534a:	87aa                	mv	a5,a0
8000534c:	85be                	mv	a1,a5
8000534e:	8522                	mv	a0,s0
80005350:	4d6010ef          	jal	80006826 <__addsf3>
80005354:	87aa                	mv	a5,a0
80005356:	853e                	mv	a0,a5
80005358:	1f3010ef          	jal	80006d4a <sqrtf>
8000535c:	872a                	mv	a4,a0
8000535e:	85ba                	mv	a1,a4
80005360:	9981a503          	lw	a0,-1640(gp) # 80003acc <.LC26>
80005364:	53d040ef          	jal	8000a0a0 <__divsf3>
80005368:	87aa                	mv	a5,a0
8000536a:	d83e                	sw	a5,48(sp)
    if (factor < 1.0f) {
8000536c:	97c1a583          	lw	a1,-1668(gp) # 80003ab0 <.LC19>
80005370:	5542                	lw	a0,48(sp)
80005372:	662010ef          	jal	800069d4 <__ltsf2>
80005376:	87aa                	mv	a5,a0
80005378:	0007de63          	bgez	a5,80005394 <.L163>
        mod_vd *= factor;
8000537c:	55c2                	lw	a1,48(sp)
8000537e:	5572                	lw	a0,60(sp)
80005380:	471040ef          	jal	80009ff0 <__mulsf3>
80005384:	87aa                	mv	a5,a0
80005386:	de3e                	sw	a5,60(sp)
        mod_vq *= factor;
80005388:	55c2                	lw	a1,48(sp)
8000538a:	5562                	lw	a0,56(sp)
8000538c:	465040ef          	jal	80009ff0 <__mulsf3>
80005390:	87aa                	mv	a5,a0
80005392:	dc3e                	sw	a5,56(sp)

80005394 <.L163>:
    }

    // Inverse park transform
    float alpha, beta;
    float pwm_phase = phase;
80005394:	4792                	lw	a5,4(sp)
80005396:	d63e                	sw	a5,44(sp)
    inverse_park(mod_vd, mod_vq, pwm_phase, &alpha, &beta);
80005398:	0878                	addi	a4,sp,28
8000539a:	101c                	addi	a5,sp,32
8000539c:	86be                	mv	a3,a5
8000539e:	5632                	lw	a2,44(sp)
800053a0:	55e2                	lw	a1,56(sp)
800053a2:	5572                	lw	a0,60(sp)
800053a4:	34bd                	jal	80004e12 <inverse_park>

    // SVM

    g_alpha = alpha;
800053a6:	5702                	lw	a4,32(sp)
800053a8:	012007b7          	lui	a5,0x1200
800053ac:	02e7a823          	sw	a4,48(a5) # 1200030 <g_alpha>
    g_beta = beta;
800053b0:	4772                	lw	a4,28(sp)
800053b2:	012007b7          	lui	a5,0x1200
800053b6:	02e7a623          	sw	a4,44(a5) # 120002c <g_beta>
    if (0 == svm(alpha, beta, &dtc_a, &dtc_b, &dtc_c)) {
800053ba:	5502                	lw	a0,32(sp)
800053bc:	45f2                	lw	a1,28(sp)
800053be:	012007b7          	lui	a5,0x1200
800053c2:	03878713          	addi	a4,a5,56 # 1200038 <dtc_c>
800053c6:	012007b7          	lui	a5,0x1200
800053ca:	03c78693          	addi	a3,a5,60 # 120003c <dtc_b>
800053ce:	012007b7          	lui	a5,0x1200
800053d2:	04078613          	addi	a2,a5,64 # 1200040 <dtc_a>
800053d6:	3c45                	jal	80004e86 <svm>
800053d8:	87aa                	mv	a5,a0
800053da:	12079d63          	bnez	a5,80005514 <.L167>

800053de <.LBB48>:
        uint16_t duty_a = (uint16_t)(dtc_a * 20000.0f);
800053de:	012007b7          	lui	a5,0x1200
800053e2:	0407a703          	lw	a4,64(a5) # 1200040 <dtc_a>
800053e6:	99c1a583          	lw	a1,-1636(gp) # 80003ad0 <.LC27>
800053ea:	853a                	mv	a0,a4
800053ec:	405040ef          	jal	80009ff0 <__mulsf3>
800053f0:	87aa                	mv	a5,a0
800053f2:	853e                	mv	a0,a5
800053f4:	70a010ef          	jal	80006afe <__fixunssfsi>
800053f8:	87aa                	mv	a5,a0
800053fa:	02f11523          	sh	a5,42(sp)
        uint16_t duty_b = (uint16_t)(dtc_b * 20000.0f);
800053fe:	012007b7          	lui	a5,0x1200
80005402:	03c7a703          	lw	a4,60(a5) # 120003c <dtc_b>
80005406:	99c1a583          	lw	a1,-1636(gp) # 80003ad0 <.LC27>
8000540a:	853a                	mv	a0,a4
8000540c:	3e5040ef          	jal	80009ff0 <__mulsf3>
80005410:	87aa                	mv	a5,a0
80005412:	853e                	mv	a0,a5
80005414:	6ea010ef          	jal	80006afe <__fixunssfsi>
80005418:	87aa                	mv	a5,a0
8000541a:	02f11423          	sh	a5,40(sp)
        uint16_t duty_c = (uint16_t)(dtc_c * 20000.0f);
8000541e:	012007b7          	lui	a5,0x1200
80005422:	0387a703          	lw	a4,56(a5) # 1200038 <dtc_c>
80005426:	99c1a583          	lw	a1,-1636(gp) # 80003ad0 <.LC27>
8000542a:	853a                	mv	a0,a4
8000542c:	3c5040ef          	jal	80009ff0 <__mulsf3>
80005430:	87aa                	mv	a5,a0
80005432:	853e                	mv	a0,a5
80005434:	6ca010ef          	jal	80006afe <__fixunssfsi>
80005438:	87aa                	mv	a5,a0
8000543a:	02f11323          	sh	a5,38(sp)

        pwmv2_shadow_register_unlock(PWM);
8000543e:	f0420537          	lui	a0,0xf0420
80005442:	fe9fe0ef          	jal	8000442a <pwmv2_shadow_register_unlock>
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(1), (reload - duty_a) >> 1, 0, false);
80005446:	012007b7          	lui	a5,0x1200
8000544a:	01c7a703          	lw	a4,28(a5) # 120001c <reload>
8000544e:	02a15783          	lhu	a5,42(sp)
80005452:	40f707b3          	sub	a5,a4,a5
80005456:	8385                	srli	a5,a5,0x1
80005458:	4701                	li	a4,0
8000545a:	4681                	li	a3,0
8000545c:	863e                	mv	a2,a5
8000545e:	4585                	li	a1,1
80005460:	f0420537          	lui	a0,0xf0420
80005464:	36b020ef          	jal	80007fce <pwmv2_set_shadow_val>
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(2), (reload + duty_a) >> 1, 0, false);
80005468:	02a15703          	lhu	a4,42(sp)
8000546c:	012007b7          	lui	a5,0x1200
80005470:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
80005474:	97ba                	add	a5,a5,a4
80005476:	8385                	srli	a5,a5,0x1
80005478:	4701                	li	a4,0
8000547a:	4681                	li	a3,0
8000547c:	863e                	mv	a2,a5
8000547e:	4589                	li	a1,2
80005480:	f0420537          	lui	a0,0xf0420
80005484:	34b020ef          	jal	80007fce <pwmv2_set_shadow_val>
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(3), (reload - duty_b) >> 1, 0, false);
80005488:	012007b7          	lui	a5,0x1200
8000548c:	01c7a703          	lw	a4,28(a5) # 120001c <reload>
80005490:	02815783          	lhu	a5,40(sp)
80005494:	40f707b3          	sub	a5,a4,a5
80005498:	8385                	srli	a5,a5,0x1
8000549a:	4701                	li	a4,0
8000549c:	4681                	li	a3,0
8000549e:	863e                	mv	a2,a5
800054a0:	458d                	li	a1,3
800054a2:	f0420537          	lui	a0,0xf0420
800054a6:	329020ef          	jal	80007fce <pwmv2_set_shadow_val>
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(4), (reload + duty_b) >> 1, 0, false);
800054aa:	02815703          	lhu	a4,40(sp)
800054ae:	012007b7          	lui	a5,0x1200
800054b2:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
800054b6:	97ba                	add	a5,a5,a4
800054b8:	8385                	srli	a5,a5,0x1
800054ba:	4701                	li	a4,0
800054bc:	4681                	li	a3,0
800054be:	863e                	mv	a2,a5
800054c0:	4591                	li	a1,4
800054c2:	f0420537          	lui	a0,0xf0420
800054c6:	309020ef          	jal	80007fce <pwmv2_set_shadow_val>
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(5), (reload - duty_c) >> 1, 0, false);
800054ca:	012007b7          	lui	a5,0x1200
800054ce:	01c7a703          	lw	a4,28(a5) # 120001c <reload>
800054d2:	02615783          	lhu	a5,38(sp)
800054d6:	40f707b3          	sub	a5,a4,a5
800054da:	8385                	srli	a5,a5,0x1
800054dc:	4701                	li	a4,0
800054de:	4681                	li	a3,0
800054e0:	863e                	mv	a2,a5
800054e2:	4595                	li	a1,5
800054e4:	f0420537          	lui	a0,0xf0420
800054e8:	2e7020ef          	jal	80007fce <pwmv2_set_shadow_val>
        pwmv2_set_shadow_val(PWM, PWMV2_SHADOW_INDEX(6), (reload + duty_c) >> 1, 0, false);
800054ec:	02615703          	lhu	a4,38(sp)
800054f0:	012007b7          	lui	a5,0x1200
800054f4:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
800054f8:	97ba                	add	a5,a5,a4
800054fa:	8385                	srli	a5,a5,0x1
800054fc:	4701                	li	a4,0
800054fe:	4681                	li	a3,0
80005500:	863e                	mv	a2,a5
80005502:	4599                	li	a1,6
80005504:	f0420537          	lui	a0,0xf0420
80005508:	2c7020ef          	jal	80007fce <pwmv2_set_shadow_val>
        pwmv2_shadow_register_lock(PWM);
8000550c:	f0420537          	lui	a0,0xf0420
80005510:	2a7020ef          	jal	80007fb6 <pwmv2_shadow_register_lock>

80005514 <.L167>:

    }
}
80005514:	0001                	nop
80005516:	40b6                	lw	ra,76(sp)
80005518:	4426                	lw	s0,72(sp)
8000551a:	6161                	addi	sp,sp,80
8000551c:	8082                	ret

Disassembly of section .text._clean_up:

8000551e <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
8000551e:	7139                	addi	sp,sp,-64

80005520 <.LBB18>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80005520:	28b01793          	bseti	a5,zero,0xb
80005524:	3047b073          	csrc	mie,a5
}
80005528:	0001                	nop
8000552a:	da02                	sw	zero,52(sp)
8000552c:	d802                	sw	zero,48(sp)
8000552e:	e40007b7          	lui	a5,0xe4000
80005532:	d63e                	sw	a5,44(sp)
80005534:	57d2                	lw	a5,52(sp)
80005536:	d43e                	sw	a5,40(sp)
80005538:	57c2                	lw	a5,48(sp)
8000553a:	d23e                	sw	a5,36(sp)

8000553c <.LBB20>:
            (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
8000553c:	57a2                	lw	a5,40(sp)
8000553e:	00c79713          	slli	a4,a5,0xc
            HPM_PLIC_THRESHOLD_OFFSET +
80005542:	57b2                	lw	a5,44(sp)
80005544:	973e                	add	a4,a4,a5
80005546:	002007b7          	lui	a5,0x200
8000554a:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
8000554c:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
8000554e:	5782                	lw	a5,32(sp)
80005550:	5712                	lw	a4,36(sp)
80005552:	c398                	sw	a4,0(a5)
}
80005554:	0001                	nop

80005556 <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
80005556:	0001                	nop

80005558 <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
80005558:	de02                	sw	zero,60(sp)
8000555a:	a82d                	j	80005594 <.L2>

8000555c <.L3>:
8000555c:	ce02                	sw	zero,28(sp)
8000555e:	57f2                	lw	a5,60(sp)
80005560:	cc3e                	sw	a5,24(sp)
80005562:	e40007b7          	lui	a5,0xe4000
80005566:	ca3e                	sw	a5,20(sp)
80005568:	47f2                	lw	a5,28(sp)
8000556a:	c83e                	sw	a5,16(sp)
8000556c:	47e2                	lw	a5,24(sp)
8000556e:	c63e                	sw	a5,12(sp)

80005570 <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
80005570:	47c2                	lw	a5,16(sp)
80005572:	00c79713          	slli	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
80005576:	47d2                	lw	a5,20(sp)
80005578:	973e                	add	a4,a4,a5
8000557a:	002007b7          	lui	a5,0x200
8000557e:	0791                	addi	a5,a5,4 # 200004 <__DLM_segment_start__+0x4>
80005580:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
80005582:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
80005584:	47a2                	lw	a5,8(sp)
80005586:	4732                	lw	a4,12(sp)
80005588:	c398                	sw	a4,0(a5)
}
8000558a:	0001                	nop

8000558c <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
8000558c:	0001                	nop

8000558e <.LBE25>:
8000558e:	57f2                	lw	a5,60(sp)
80005590:	0785                	addi	a5,a5,1
80005592:	de3e                	sw	a5,60(sp)

80005594 <.L2>:
80005594:	5772                	lw	a4,60(sp)
80005596:	07f00793          	li	a5,127
8000559a:	fce7f1e3          	bgeu	a5,a4,8000555c <.L3>

8000559e <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
8000559e:	dc02                	sw	zero,56(sp)
800055a0:	a821                	j	800055b8 <.L4>

800055a2 <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
800055a2:	57e2                	lw	a5,56(sp)
800055a4:	00279713          	slli	a4,a5,0x2
800055a8:	e40027b7          	lui	a5,0xe4002
800055ac:	97ba                	add	a5,a5,a4
800055ae:	0007a023          	sw	zero,0(a5) # e4002000 <__FLASH_segment_end__+0x63f02000>
    for (uint32_t i = 0; i < 4; i++) {
800055b2:	57e2                	lw	a5,56(sp)
800055b4:	0785                	addi	a5,a5,1
800055b6:	dc3e                	sw	a5,56(sp)

800055b8 <.L4>:
800055b8:	5762                	lw	a4,56(sp)
800055ba:	478d                	li	a5,3
800055bc:	fee7f3e3          	bgeu	a5,a4,800055a2 <.L5>

800055c0 <.LBE29>:
    }
}
800055c0:	0001                	nop
800055c2:	0001                	nop
800055c4:	6121                	addi	sp,sp,64
800055c6:	8082                	ret

Disassembly of section .text.syscall_handler:

800055c8 <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
800055c8:	1101                	addi	sp,sp,-32
800055ca:	ce2a                	sw	a0,28(sp)
800055cc:	cc2e                	sw	a1,24(sp)
800055ce:	ca32                	sw	a2,20(sp)
800055d0:	c836                	sw	a3,16(sp)
800055d2:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
800055d4:	0001                	nop
800055d6:	6105                	addi	sp,sp,32
800055d8:	8082                	ret

Disassembly of section .text.system_init:

800055da <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
800055da:	7179                	addi	sp,sp,-48
800055dc:	d606                	sw	ra,44(sp)

800055de <.LBB16>:
#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
800055de:	306027f3          	csrr	a5,mcounteren
800055e2:	ce3e                	sw	a5,28(sp)
800055e4:	47f2                	lw	a5,28(sp)

800055e6 <.LBE16>:
800055e6:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
800055e8:	47e2                	lw	a5,24(sp)
800055ea:	0017e793          	ori	a5,a5,1
800055ee:	30679073          	csrw	mcounteren,a5
800055f2:	47a1                	li	a5,8
800055f4:	c83e                	sw	a5,16(sp)

800055f6 <.LBB17>:
    return read_clear_csr(CSR_MSTATUS, mask);
800055f6:	c602                	sw	zero,12(sp)
800055f8:	47c2                	lw	a5,16(sp)
800055fa:	3007b7f3          	csrrc	a5,mstatus,a5
800055fe:	c63e                	sw	a5,12(sp)
80005600:	47b2                	lw	a5,12(sp)

80005602 <.LBE19>:
80005602:	0001                	nop

80005604 <.LBB20>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80005604:	28b01793          	bseti	a5,zero,0xb
80005608:	3047b073          	csrc	mie,a5
}
8000560c:	0001                	nop

8000560e <.LBE20>:
    disable_irq_from_intc();
#ifdef USE_S_MODE_IRQ
    disable_s_irq_from_intc();
#endif

    enable_plic_feature();
8000560e:	024030ef          	jal	80008632 <enable_plic_feature>

80005612 <.LBB22>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
80005612:	28b01793          	bseti	a5,zero,0xb
80005616:	3047a073          	csrs	mie,a5
}
8000561a:	0001                	nop
8000561c:	47a1                	li	a5,8
8000561e:	ca3e                	sw	a5,20(sp)

80005620 <.LBB24>:
    set_csr(CSR_MSTATUS, mask);
80005620:	47d2                	lw	a5,20(sp)
80005622:	3007a073          	csrs	mstatus,a5
}
80005626:	0001                	nop

80005628 <.LBE24>:
#else
#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif
#endif
}
80005628:	0001                	nop
8000562a:	50b2                	lw	ra,44(sp)
8000562c:	6145                	addi	sp,sp,48
8000562e:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

80005630 <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
80005630:	1141                	addi	sp,sp,-16
80005632:	c62a                	sw	a0,12(sp)
80005634:	87ae                	mv	a5,a1
80005636:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
8000563a:	00a15783          	lhu	a5,10(sp)
8000563e:	4732                	lw	a4,12(sp)
80005640:	078a                	slli	a5,a5,0x2
80005642:	97ba                	add	a5,a5,a4
80005644:	4398                	lw	a4,0(a5)
80005646:	400007b7          	lui	a5,0x40000
8000564a:	8ff9                	and	a5,a5,a4
8000564c:	00f037b3          	snez	a5,a5
80005650:	0ff7f793          	zext.b	a5,a5
}
80005654:	853e                	mv	a0,a5
80005656:	0141                	addi	sp,sp,16
80005658:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

8000565a <sysctl_config_clock>:
    }
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node_index, clock_source_t source, uint32_t divide_by)
{
8000565a:	7179                	addi	sp,sp,-48
8000565c:	d606                	sw	ra,44(sp)
8000565e:	c62a                	sw	a0,12(sp)
80005660:	87ae                	mv	a5,a1
80005662:	8732                	mv	a4,a2
80005664:	c236                	sw	a3,4(sp)
80005666:	00f105a3          	sb	a5,11(sp)
8000566a:	87ba                	mv	a5,a4
8000566c:	00f10523          	sb	a5,10(sp)
    uint32_t node = (uint32_t) node_index;
80005670:	00b14783          	lbu	a5,11(sp)
80005674:	ce3e                	sw	a5,28(sp)
    if (node >= clock_node_adc_start) {
80005676:	4772                	lw	a4,28(sp)
80005678:	02800793          	li	a5,40
8000567c:	00e7f463          	bgeu	a5,a4,80005684 <.L76>
        return status_invalid_argument;
80005680:	4789                	li	a5,2
80005682:	a8b9                	j	800056e0 <.L77>

80005684 <.L76>:
    }

    if (source >= clock_source_general_source_end) {
80005684:	00a14703          	lbu	a4,10(sp)
80005688:	479d                	li	a5,7
8000568a:	00e7f463          	bgeu	a5,a4,80005692 <.L78>
        return status_invalid_argument;
8000568e:	4789                	li	a5,2
80005690:	a881                	j	800056e0 <.L77>

80005692 <.L78>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
80005692:	4732                	lw	a4,12(sp)
80005694:	47f2                	lw	a5,28(sp)
80005696:	60078793          	addi	a5,a5,1536 # 40000600 <__NONCACHEABLE_RAM_segment_end__+0x3edc0600>
8000569a:	078a                	slli	a5,a5,0x2
8000569c:	97ba                	add	a5,a5,a4
8000569e:	439c                	lw	a5,0(a5)
800056a0:	8007f713          	andi	a4,a5,-2048
        (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
800056a4:	00a14783          	lbu	a5,10(sp)
800056a8:	07a2                	slli	a5,a5,0x8
800056aa:	7007f693          	andi	a3,a5,1792
800056ae:	4792                	lw	a5,4(sp)
800056b0:	17fd                	addi	a5,a5,-1
800056b2:	0ff7f793          	zext.b	a5,a5
800056b6:	8fd5                	or	a5,a5,a3
    ptr->CLOCK[node] = (ptr->CLOCK[node] & ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK)) |
800056b8:	8f5d                	or	a4,a4,a5
800056ba:	46b2                	lw	a3,12(sp)
800056bc:	47f2                	lw	a5,28(sp)
800056be:	60078793          	addi	a5,a5,1536
800056c2:	078a                	slli	a5,a5,0x2
800056c4:	97b6                	add	a5,a5,a3
800056c6:	c398                	sw	a4,0(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
800056c8:	0001                	nop

800056ca <.L79>:
800056ca:	45f2                	lw	a1,28(sp)
800056cc:	4532                	lw	a0,12(sp)
800056ce:	791020ef          	jal	8000865e <sysctl_clock_target_is_busy>
800056d2:	87aa                	mv	a5,a0
800056d4:	fbfd                	bnez	a5,800056ca <.L79>
    }
    if (node == clock_node_cpu0) {
800056d6:	47f2                	lw	a5,28(sp)
800056d8:	e399                	bnez	a5,800056de <.L80>
        clock_update_core_clock();
800056da:	1be030ef          	jal	80008898 <clock_update_core_clock>

800056de <.L80>:
    }
    return status_success;
800056de:	4781                	li	a5,0

800056e0 <.L77>:
}
800056e0:	853e                	mv	a0,a5
800056e2:	50b2                	lw	ra,44(sp)
800056e4:	6145                	addi	sp,sp,48
800056e6:	8082                	ret

Disassembly of section .text.hpm_csr_get_core_cycle:

800056e8 <hpm_csr_get_core_cycle>:
 *          - in user mode if the device supports M/U mode
 *
 * @return CSR cycle value in 64-bit
 */
static inline uint64_t hpm_csr_get_core_cycle(void)
{
800056e8:	7179                	addi	sp,sp,-48

800056ea <.LBB2>:
    uint64_t result;
    uint32_t resultl_first = read_csr(CSR_CYCLE);
800056ea:	c0002f73          	rdcycle	t5
800056ee:	d27a                	sw	t5,36(sp)
800056f0:	5f12                	lw	t5,36(sp)

800056f2 <.LBE2>:
800056f2:	d07a                	sw	t5,32(sp)

800056f4 <.LBB3>:
    uint32_t resulth = read_csr(CSR_CYCLEH);
800056f4:	c8002f73          	rdcycleh	t5
800056f8:	ce7a                	sw	t5,28(sp)
800056fa:	4f72                	lw	t5,28(sp)

800056fc <.LBE3>:
800056fc:	cc7a                	sw	t5,24(sp)

800056fe <.LBB4>:
    uint32_t resultl_second = read_csr(CSR_CYCLE);
800056fe:	c0002f73          	rdcycle	t5
80005702:	ca7a                	sw	t5,20(sp)
80005704:	4f52                	lw	t5,20(sp)

80005706 <.LBE4>:
80005706:	c87a                	sw	t5,16(sp)
    if (resultl_first < resultl_second) {
80005708:	5f82                	lw	t6,32(sp)
8000570a:	4f42                	lw	t5,16(sp)
8000570c:	03eff263          	bgeu	t6,t5,80005730 <.L2>
        result = ((uint64_t)resulth << 32) | resultl_first; /* if CYCLE didn't roll over, return the value directly */
80005710:	47e2                	lw	a5,24(sp)
80005712:	8e3e                	mv	t3,a5
80005714:	4e81                	li	t4,0
80005716:	000e1693          	slli	a3,t3,0x0
8000571a:	4601                	li	a2,0
8000571c:	5782                	lw	a5,32(sp)
8000571e:	883e                	mv	a6,a5
80005720:	4881                	li	a7,0
80005722:	010667b3          	or	a5,a2,a6
80005726:	d43e                	sw	a5,40(sp)
80005728:	0116e7b3          	or	a5,a3,a7
8000572c:	d63e                	sw	a5,44(sp)
8000572e:	a025                	j	80005756 <.L3>

80005730 <.L2>:
    } else {
        resulth = read_csr(CSR_CYCLEH);
80005730:	c80026f3          	rdcycleh	a3
80005734:	c636                	sw	a3,12(sp)
80005736:	46b2                	lw	a3,12(sp)

80005738 <.LBE5>:
80005738:	cc36                	sw	a3,24(sp)
        result = ((uint64_t)resulth << 32) | resultl_second; /* if CYCLE rolled over, need to get the CYCLEH again */
8000573a:	46e2                	lw	a3,24(sp)
8000573c:	8336                	mv	t1,a3
8000573e:	4381                	li	t2,0
80005740:	00031793          	slli	a5,t1,0x0
80005744:	4701                	li	a4,0
80005746:	46c2                	lw	a3,16(sp)
80005748:	8536                	mv	a0,a3
8000574a:	4581                	li	a1,0
8000574c:	00a766b3          	or	a3,a4,a0
80005750:	d436                	sw	a3,40(sp)
80005752:	8fcd                	or	a5,a5,a1
80005754:	d63e                	sw	a5,44(sp)

80005756 <.L3>:
    }
    return result;
80005756:	5722                	lw	a4,40(sp)
80005758:	57b2                	lw	a5,44(sp)
 }
8000575a:	853a                	mv	a0,a4
8000575c:	85be                	mv	a1,a5
8000575e:	6145                	addi	sp,sp,48
80005760:	8082                	ret

Disassembly of section .text.clock_get_frequency:

80005762 <clock_get_frequency>:

/***********************************************************************************************************************
 * Codes
 **********************************************************************************************************************/
uint32_t clock_get_frequency(clock_name_t clock_name)
{
80005762:	7179                	addi	sp,sp,-48
80005764:	d606                	sw	ra,44(sp)
80005766:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80005768:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
8000576a:	47b2                	lw	a5,12(sp)
8000576c:	83a1                	srli	a5,a5,0x8
8000576e:	0ff7f793          	zext.b	a5,a5
80005772:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80005774:	47b2                	lw	a5,12(sp)
80005776:	0ff7f793          	zext.b	a5,a5
8000577a:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
8000577c:	4762                	lw	a4,24(sp)
8000577e:	47a9                	li	a5,10
80005780:	08e7e063          	bltu	a5,a4,80005800 <.L16>
80005784:	47e2                	lw	a5,24(sp)
80005786:	00279713          	slli	a4,a5,0x2
8000578a:	a0418793          	addi	a5,gp,-1532 # 80003b38 <.L18>
8000578e:	97ba                	add	a5,a5,a4
80005790:	439c                	lw	a5,0(a5)
80005792:	8782                	jr	a5

80005794 <.L28>:
    case CLK_SRC_GROUP_COMMON:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
80005794:	47d2                	lw	a5,20(sp)
80005796:	0ff7f793          	zext.b	a5,a5
8000579a:	853e                	mv	a0,a5
8000579c:	2205                	jal	800058bc <get_frequency_for_ip_in_common_group>
8000579e:	ce2a                	sw	a0,28(sp)
        break;
800057a0:	a095                	j	80005804 <.L29>

800057a2 <.L27>:
    case CLK_SRC_GROUP_ADC:
        clk_freq = get_frequency_for_adc(node_or_instance);
800057a2:	4552                	lw	a0,20(sp)
800057a4:	7a7020ef          	jal	8000874a <get_frequency_for_adc>
800057a8:	ce2a                	sw	a0,28(sp)
        break;
800057aa:	a8a9                	j	80005804 <.L29>

800057ac <.L26>:
    case CLK_SRC_GROUP_EWDG:
        clk_freq = get_frequency_for_ewdg(node_or_instance);
800057ac:	4552                	lw	a0,20(sp)
800057ae:	030030ef          	jal	800087de <get_frequency_for_ewdg>
800057b2:	ce2a                	sw	a0,28(sp)
        break;
800057b4:	a881                	j	80005804 <.L29>

800057b6 <.L20>:
    case CLK_SRC_GROUP_PEWDG:
        clk_freq = get_frequency_for_pewdg();
800057b6:	05c030ef          	jal	80008812 <get_frequency_for_pewdg>
800057ba:	ce2a                	sw	a0,28(sp)
        break;
800057bc:	a0a1                	j	80005804 <.L29>

800057be <.L21>:
    case CLK_SRC_GROUP_PMIC:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
800057be:	016e37b7          	lui	a5,0x16e3
800057c2:	60078793          	addi	a5,a5,1536 # 16e3600 <__NONCACHEABLE_RAM_segment_end__+0x4a3600>
800057c6:	ce3e                	sw	a5,28(sp)
        break;
800057c8:	a835                	j	80005804 <.L29>

800057ca <.L25>:
    case CLK_SRC_GROUP_AHB:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
800057ca:	4509                	li	a0,2
800057cc:	28c5                	jal	800058bc <get_frequency_for_ip_in_common_group>
800057ce:	ce2a                	sw	a0,28(sp)
        break;
800057d0:	a815                	j	80005804 <.L29>

800057d2 <.L24>:
    case CLK_SRC_GROUP_AXIF:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axif);
800057d2:	450d                	li	a0,3
800057d4:	20e5                	jal	800058bc <get_frequency_for_ip_in_common_group>
800057d6:	ce2a                	sw	a0,28(sp)
        break;
800057d8:	a035                	j	80005804 <.L29>

800057da <.L23>:
    case CLK_SRC_GROUP_AXIS:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axis);
800057da:	4511                	li	a0,4
800057dc:	20c5                	jal	800058bc <get_frequency_for_ip_in_common_group>
800057de:	ce2a                	sw	a0,28(sp)
        break;
800057e0:	a015                	j	80005804 <.L29>

800057e2 <.L22>:
    case CLK_SRC_GROUP_AXIC:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axic);
800057e2:	4515                	li	a0,5
800057e4:	28e1                	jal	800058bc <get_frequency_for_ip_in_common_group>
800057e6:	ce2a                	sw	a0,28(sp)
        break;
800057e8:	a831                	j	80005804 <.L29>

800057ea <.L19>:
    case CLK_SRC_GROUP_CPU0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu0);
800057ea:	4501                	li	a0,0
800057ec:	28c1                	jal	800058bc <get_frequency_for_ip_in_common_group>
800057ee:	ce2a                	sw	a0,28(sp)
        break;
800057f0:	a811                	j	80005804 <.L29>

800057f2 <.L17>:
    case CLK_SRC_GROUP_SRC:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
800057f2:	47d2                	lw	a5,20(sp)
800057f4:	0ff7f793          	zext.b	a5,a5
800057f8:	853e                	mv	a0,a5
800057fa:	2811                	jal	8000580e <.LFE132>
800057fc:	ce2a                	sw	a0,28(sp)
        break;
800057fe:	a019                	j	80005804 <.L29>

80005800 <.L16>:
    default:
        clk_freq = 0UL;
80005800:	ce02                	sw	zero,28(sp)
        break;
80005802:	0001                	nop

80005804 <.L29>:
    }
    return clk_freq;
80005804:	47f2                	lw	a5,28(sp)
}
80005806:	853e                	mv	a0,a5
80005808:	50b2                	lw	ra,44(sp)
8000580a:	6145                	addi	sp,sp,48
8000580c:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

8000580e <get_frequency_for_source>:

uint32_t get_frequency_for_source(clock_source_t source)
{
8000580e:	7179                	addi	sp,sp,-48
80005810:	d606                	sw	ra,44(sp)
80005812:	87aa                	mv	a5,a0
80005814:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
80005818:	ce02                	sw	zero,28(sp)
    switch (source) {
8000581a:	00f14783          	lbu	a5,15(sp)
8000581e:	471d                	li	a4,7
80005820:	08f76763          	bltu	a4,a5,800058ae <.L32>
80005824:	00279713          	slli	a4,a5,0x2
80005828:	a3018793          	addi	a5,gp,-1488 # 80003b64 <.L34>
8000582c:	97ba                	add	a5,a5,a4
8000582e:	439c                	lw	a5,0(a5)
80005830:	8782                	jr	a5

80005832 <.L41>:
    case clock_source_osc0_clk0:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
80005832:	016e37b7          	lui	a5,0x16e3
80005836:	60078793          	addi	a5,a5,1536 # 16e3600 <__NONCACHEABLE_RAM_segment_end__+0x4a3600>
8000583a:	ce3e                	sw	a5,28(sp)
        break;
8000583c:	a89d                	j	800058b2 <.L42>

8000583e <.L40>:
    case clock_source_pll0_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0);
8000583e:	4601                	li	a2,0
80005840:	4581                	li	a1,0
80005842:	f40c0537          	lui	a0,0xf40c0
80005846:	60b030ef          	jal	80009650 <pllctlv2_get_pll_postdiv_freq_in_hz>
8000584a:	ce2a                	sw	a0,28(sp)
        break;
8000584c:	a09d                	j	800058b2 <.L42>

8000584e <.L39>:
    case clock_source_pll0_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1);
8000584e:	4605                	li	a2,1
80005850:	4581                	li	a1,0
80005852:	f40c0537          	lui	a0,0xf40c0
80005856:	5fb030ef          	jal	80009650 <pllctlv2_get_pll_postdiv_freq_in_hz>
8000585a:	ce2a                	sw	a0,28(sp)
        break;
8000585c:	a899                	j	800058b2 <.L42>

8000585e <.L38>:
    case clock_source_pll1_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk0);
8000585e:	4601                	li	a2,0
80005860:	4585                	li	a1,1
80005862:	f40c0537          	lui	a0,0xf40c0
80005866:	5eb030ef          	jal	80009650 <pllctlv2_get_pll_postdiv_freq_in_hz>
8000586a:	ce2a                	sw	a0,28(sp)
        break;
8000586c:	a099                	j	800058b2 <.L42>

8000586e <.L37>:
    case clock_source_pll1_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk1);
8000586e:	4605                	li	a2,1
80005870:	4585                	li	a1,1
80005872:	f40c0537          	lui	a0,0xf40c0
80005876:	5db030ef          	jal	80009650 <pllctlv2_get_pll_postdiv_freq_in_hz>
8000587a:	ce2a                	sw	a0,28(sp)
        break;
8000587c:	a81d                	j	800058b2 <.L42>

8000587e <.L36>:
    case clock_source_pll1_clk2:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll1, pllctlv2_clk2);
8000587e:	4609                	li	a2,2
80005880:	4585                	li	a1,1
80005882:	f40c0537          	lui	a0,0xf40c0
80005886:	5cb030ef          	jal	80009650 <pllctlv2_get_pll_postdiv_freq_in_hz>
8000588a:	ce2a                	sw	a0,28(sp)
        break;
8000588c:	a01d                	j	800058b2 <.L42>

8000588e <.L35>:
    case clock_source_pll2_clk0:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll2, pllctlv2_clk0);
8000588e:	4601                	li	a2,0
80005890:	4589                	li	a1,2
80005892:	f40c0537          	lui	a0,0xf40c0
80005896:	5bb030ef          	jal	80009650 <pllctlv2_get_pll_postdiv_freq_in_hz>
8000589a:	ce2a                	sw	a0,28(sp)
        break;
8000589c:	a819                	j	800058b2 <.L42>

8000589e <.L33>:
    case clock_source_pll2_clk1:
        clk_freq = pllctlv2_get_pll_postdiv_freq_in_hz(HPM_PLLCTLV2, pllctlv2_pll2, pllctlv2_clk1);
8000589e:	4605                	li	a2,1
800058a0:	4589                	li	a1,2
800058a2:	f40c0537          	lui	a0,0xf40c0
800058a6:	5ab030ef          	jal	80009650 <pllctlv2_get_pll_postdiv_freq_in_hz>
800058aa:	ce2a                	sw	a0,28(sp)
        break;
800058ac:	a019                	j	800058b2 <.L42>

800058ae <.L32>:
    default:
        clk_freq = 0UL;
800058ae:	ce02                	sw	zero,28(sp)
        break;
800058b0:	0001                	nop

800058b2 <.L42>:
    }

    return clk_freq;
800058b2:	47f2                	lw	a5,28(sp)
}
800058b4:	853e                	mv	a0,a5
800058b6:	50b2                	lw	ra,44(sp)
800058b8:	6145                	addi	sp,sp,48
800058ba:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

800058bc <get_frequency_for_ip_in_common_group>:

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
800058bc:	7139                	addi	sp,sp,-64
800058be:	de06                	sw	ra,60(sp)
800058c0:	87aa                	mv	a5,a0
800058c2:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
800058c6:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
800058c8:	00f14783          	lbu	a5,15(sp)
800058cc:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
800058ce:	5722                	lw	a4,40(sp)
800058d0:	02a00793          	li	a5,42
800058d4:	04e7e563          	bltu	a5,a4,8000591e <.L45>

800058d8 <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
800058d8:	57a2                	lw	a5,40(sp)
800058da:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
800058dc:	f4000737          	lui	a4,0xf4000
800058e0:	5792                	lw	a5,36(sp)
800058e2:	60078793          	addi	a5,a5,1536
800058e6:	078a                	slli	a5,a5,0x2
800058e8:	97ba                	add	a5,a5,a4
800058ea:	439c                	lw	a5,0(a5)
800058ec:	0ff7f793          	zext.b	a5,a5
800058f0:	0785                	addi	a5,a5,1
800058f2:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
800058f4:	f4000737          	lui	a4,0xf4000
800058f8:	5792                	lw	a5,36(sp)
800058fa:	60078793          	addi	a5,a5,1536
800058fe:	078a                	slli	a5,a5,0x2
80005900:	97ba                	add	a5,a5,a4
80005902:	439c                	lw	a5,0(a5)
80005904:	83a1                	srli	a5,a5,0x8
80005906:	8b9d                	andi	a5,a5,7
80005908:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
8000590c:	01f14783          	lbu	a5,31(sp)
80005910:	853e                	mv	a0,a5
80005912:	3df5                	jal	8000580e <get_frequency_for_source>
80005914:	872a                	mv	a4,a0
80005916:	5782                	lw	a5,32(sp)
80005918:	02f757b3          	divu	a5,a4,a5
8000591c:	d63e                	sw	a5,44(sp)

8000591e <.L45>:
    }
    return clk_freq;
8000591e:	57b2                	lw	a5,44(sp)
}
80005920:	853e                	mv	a0,a5
80005922:	50f2                	lw	ra,60(sp)
80005924:	6121                	addi	sp,sp,64
80005926:	8082                	ret

Disassembly of section .text.clock_get_source:

80005928 <clock_get_source>:

    return freq_in_hz;
}

clk_src_t clock_get_source(clock_name_t clock_name)
{
80005928:	1101                	addi	sp,sp,-32
8000592a:	c62a                	sw	a0,12(sp)
    uint8_t clk_src_group = CLK_SRC_GROUP_INVALID;
8000592c:	47ad                	li	a5,11
8000592e:	00f10fa3          	sb	a5,31(sp)
    uint8_t clk_src_index = 0xFU;
80005932:	47bd                	li	a5,15
80005934:	00f10f23          	sb	a5,30(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80005938:	47b2                	lw	a5,12(sp)
8000593a:	83a1                	srli	a5,a5,0x8
8000593c:	0ff7f793          	zext.b	a5,a5
80005940:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80005942:	47b2                	lw	a5,12(sp)
80005944:	0ff7f793          	zext.b	a5,a5
80005948:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
8000594a:	4762                	lw	a4,24(sp)
8000594c:	47a9                	li	a5,10
8000594e:	0ae7ec63          	bltu	a5,a4,80005a06 <.L61>
80005952:	47e2                	lw	a5,24(sp)
80005954:	00279713          	slli	a4,a5,0x2
80005958:	a5018793          	addi	a5,gp,-1456 # 80003b84 <.L63>
8000595c:	97ba                	add	a5,a5,a4
8000595e:	439c                	lw	a5,0(a5)
80005960:	8782                	jr	a5

80005962 <.L68>:
    case CLK_SRC_GROUP_COMMON:
        clk_src_group = CLK_SRC_GROUP_COMMON;
80005962:	00010fa3          	sb	zero,31(sp)
        clk_src_index = SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[node_or_instance]);
80005966:	f4000737          	lui	a4,0xf4000
8000596a:	47d2                	lw	a5,20(sp)
8000596c:	60078793          	addi	a5,a5,1536
80005970:	078a                	slli	a5,a5,0x2
80005972:	97ba                	add	a5,a5,a4
80005974:	439c                	lw	a5,0(a5)
80005976:	83a1                	srli	a5,a5,0x8
80005978:	0ff7f793          	zext.b	a5,a5
8000597c:	8b9d                	andi	a5,a5,7
8000597e:	00f10f23          	sb	a5,30(sp)
        break;
80005982:	a849                	j	80005a14 <.L69>

80005984 <.L67>:
    case CLK_SRC_GROUP_ADC:
        if (node_or_instance < ADC_INSTANCE_NUM) {
80005984:	4752                	lw	a4,20(sp)
80005986:	4785                	li	a5,1
80005988:	08e7e363          	bltu	a5,a4,80005a0e <.L75>
            clk_src_group = CLK_SRC_GROUP_ADC;
8000598c:	4785                	li	a5,1
8000598e:	00f10fa3          	sb	a5,31(sp)
            clk_src_index = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[node_or_instance]);
80005992:	f4000737          	lui	a4,0xf4000
80005996:	47d2                	lw	a5,20(sp)
80005998:	70078793          	addi	a5,a5,1792
8000599c:	078a                	slli	a5,a5,0x2
8000599e:	97ba                	add	a5,a5,a4
800059a0:	439c                	lw	a5,0(a5)
800059a2:	83a1                	srli	a5,a5,0x8
800059a4:	0ff7f793          	zext.b	a5,a5
800059a8:	8b85                	andi	a5,a5,1
800059aa:	00f10f23          	sb	a5,30(sp)
        }
        break;
800059ae:	a085                	j	80005a0e <.L75>

800059b0 <.L66>:
    case CLK_SRC_GROUP_EWDG:
        if (node_or_instance < EWDG_INSTANCE_NUM) {
800059b0:	4752                	lw	a4,20(sp)
800059b2:	4785                	li	a5,1
800059b4:	04e7ef63          	bltu	a5,a4,80005a12 <.L76>
            clk_src_group = CLK_SRC_GROUP_EWDG;
800059b8:	4789                	li	a5,2
800059ba:	00f10fa3          	sb	a5,31(sp)
            clk_src_index = EWDG_CTRL0_CLK_SEL_GET(s_wdgs[node_or_instance]->CTRL0);
800059be:	9fc18713          	addi	a4,gp,-1540 # 80003b30 <s_wdgs>
800059c2:	47d2                	lw	a5,20(sp)
800059c4:	078a                	slli	a5,a5,0x2
800059c6:	97ba                	add	a5,a5,a4
800059c8:	439c                	lw	a5,0(a5)
800059ca:	439c                	lw	a5,0(a5)
800059cc:	83f5                	srli	a5,a5,0x1d
800059ce:	0ff7f793          	zext.b	a5,a5
800059d2:	8b85                	andi	a5,a5,1
800059d4:	00f10f23          	sb	a5,30(sp)
        }
        break;
800059d8:	a82d                	j	80005a12 <.L76>

800059da <.L64>:
    case CLK_SRC_GROUP_PEWDG:
        clk_src_group = CLK_SRC_GROUP_PEWDG;
800059da:	47a1                	li	a5,8
800059dc:	00f10fa3          	sb	a5,31(sp)
        clk_src_index = EWDG_CTRL0_CLK_SEL_GET(HPM_PEWDG->CTRL0);
800059e0:	f41287b7          	lui	a5,0xf4128
800059e4:	439c                	lw	a5,0(a5)
800059e6:	83f5                	srli	a5,a5,0x1d
800059e8:	0ff7f793          	zext.b	a5,a5
800059ec:	8b85                	andi	a5,a5,1
800059ee:	00f10f23          	sb	a5,30(sp)
        break;
800059f2:	a00d                	j	80005a14 <.L69>

800059f4 <.L65>:
    case CLK_SRC_GROUP_PMIC:
        clk_src_group = CLK_SRC_GROUP_COMMON;
800059f4:	00010fa3          	sb	zero,31(sp)
        clk_src_index = clock_source_osc0_clk0;
800059f8:	00010f23          	sb	zero,30(sp)
        break;
800059fc:	a821                	j	80005a14 <.L69>

800059fe <.L62>:
    case CLK_SRC_GROUP_SRC:
        clk_src_index = (clk_src_t) node_or_instance;
800059fe:	47d2                	lw	a5,20(sp)
80005a00:	00f10f23          	sb	a5,30(sp)
        break;
80005a04:	a801                	j	80005a14 <.L69>

80005a06 <.L61>:
    default:
        clk_src_group = CLK_SRC_GROUP_INVALID;
80005a06:	47ad                	li	a5,11
80005a08:	00f10fa3          	sb	a5,31(sp)
        break;
80005a0c:	a021                	j	80005a14 <.L69>

80005a0e <.L75>:
        break;
80005a0e:	0001                	nop
80005a10:	a011                	j	80005a14 <.L69>

80005a12 <.L76>:
        break;
80005a12:	0001                	nop

80005a14 <.L69>:
    }

    clk_src_t clk_src;
    if (clk_src_group != CLK_SRC_GROUP_INVALID) {
80005a14:	01f14703          	lbu	a4,31(sp)
80005a18:	47ad                	li	a5,11
80005a1a:	00f70f63          	beq	a4,a5,80005a38 <.L72>
        clk_src = MAKE_CLK_SRC(clk_src_group, clk_src_index);
80005a1e:	01f10783          	lb	a5,31(sp)
80005a22:	0792                	slli	a5,a5,0x4
80005a24:	60479713          	sext.b	a4,a5
80005a28:	01e10783          	lb	a5,30(sp)
80005a2c:	8fd9                	or	a5,a5,a4
80005a2e:	60479793          	sext.b	a5,a5
80005a32:	00f10ea3          	sb	a5,29(sp)
80005a36:	a029                	j	80005a40 <.L73>

80005a38 <.L72>:
    } else {
        clk_src = clk_src_invalid;
80005a38:	fbf00793          	li	a5,-65
80005a3c:	00f10ea3          	sb	a5,29(sp)

80005a40 <.L73>:
    }

    return clk_src;
80005a40:	01d14783          	lbu	a5,29(sp)
}
80005a44:	853e                	mv	a0,a5
80005a46:	6105                	addi	sp,sp,32
80005a48:	8082                	ret

Disassembly of section .text.clock_set_adc_source:

80005a4a <clock_set_adc_source>:
    }
    return clk_divider;
}

hpm_stat_t clock_set_adc_source(clock_name_t clock_name, clk_src_t src)
{
80005a4a:	1101                	addi	sp,sp,-32
80005a4c:	c62a                	sw	a0,12(sp)
80005a4e:	87ae                	mv	a5,a1
80005a50:	00f105a3          	sb	a5,11(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80005a54:	47b2                	lw	a5,12(sp)
80005a56:	83a1                	srli	a5,a5,0x8
80005a58:	0ff7f793          	zext.b	a5,a5
80005a5c:	ce3e                	sw	a5,28(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80005a5e:	47b2                	lw	a5,12(sp)
80005a60:	0ff7f793          	zext.b	a5,a5
80005a64:	cc3e                	sw	a5,24(sp)

    if ((clk_src_type != CLK_SRC_GROUP_ADC) || (node_or_instance >= ADC_INSTANCE_NUM)) {
80005a66:	4772                	lw	a4,28(sp)
80005a68:	4785                	li	a5,1
80005a6a:	00f71663          	bne	a4,a5,80005a76 <.L95>
80005a6e:	4762                	lw	a4,24(sp)
80005a70:	4785                	li	a5,1
80005a72:	00e7f663          	bgeu	a5,a4,80005a7e <.L96>

80005a76 <.L95>:
        return status_clk_invalid;
80005a76:	6795                	lui	a5,0x5
80005a78:	5f278793          	addi	a5,a5,1522 # 55f2 <__HEAPSIZE__+0x15f2>
80005a7c:	a899                	j	80005ad2 <.L97>

80005a7e <.L96>:
    }

    if ((src < clk_adc_src_ahb0) || (src > clk_adc_src_ana0)) {
80005a7e:	00b14703          	lbu	a4,11(sp)
80005a82:	47bd                	li	a5,15
80005a84:	00e7f763          	bgeu	a5,a4,80005a92 <.L98>
80005a88:	00b14703          	lbu	a4,11(sp)
80005a8c:	47c5                	li	a5,17
80005a8e:	00e7f663          	bgeu	a5,a4,80005a9a <.L99>

80005a92 <.L98>:
        return status_clk_src_invalid;
80005a92:	6795                	lui	a5,0x5
80005a94:	5f178793          	addi	a5,a5,1521 # 55f1 <__HEAPSIZE__+0x15f1>
80005a98:	a82d                	j	80005ad2 <.L97>

80005a9a <.L99>:
    }

    uint32_t clk_src_index = GET_CLK_SRC_INDEX(src);
80005a9a:	00b14783          	lbu	a5,11(sp)
80005a9e:	8bbd                	andi	a5,a5,15
80005aa0:	ca3e                	sw	a5,20(sp)
    HPM_SYSCTL->ADCCLK[node_or_instance] =
            (HPM_SYSCTL->ADCCLK[node_or_instance] & ~SYSCTL_ADCCLK_MUX_MASK) | SYSCTL_ADCCLK_MUX_SET(clk_src_index);
80005aa2:	f4000737          	lui	a4,0xf4000
80005aa6:	47e2                	lw	a5,24(sp)
80005aa8:	70078793          	addi	a5,a5,1792
80005aac:	078a                	slli	a5,a5,0x2
80005aae:	97ba                	add	a5,a5,a4
80005ab0:	439c                	lw	a5,0(a5)
80005ab2:	eff7f713          	andi	a4,a5,-257
80005ab6:	47d2                	lw	a5,20(sp)
80005ab8:	07a2                	slli	a5,a5,0x8
80005aba:	1007f793          	andi	a5,a5,256
    HPM_SYSCTL->ADCCLK[node_or_instance] =
80005abe:	f40006b7          	lui	a3,0xf4000
            (HPM_SYSCTL->ADCCLK[node_or_instance] & ~SYSCTL_ADCCLK_MUX_MASK) | SYSCTL_ADCCLK_MUX_SET(clk_src_index);
80005ac2:	8f5d                	or	a4,a4,a5
    HPM_SYSCTL->ADCCLK[node_or_instance] =
80005ac4:	47e2                	lw	a5,24(sp)
80005ac6:	70078793          	addi	a5,a5,1792
80005aca:	078a                	slli	a5,a5,0x2
80005acc:	97b6                	add	a5,a5,a3
80005ace:	c398                	sw	a4,0(a5)

    return status_success;
80005ad0:	4781                	li	a5,0

80005ad2 <.L97>:
}
80005ad2:	853e                	mv	a0,a5
80005ad4:	6105                	addi	sp,sp,32
80005ad6:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

80005ad8 <clock_set_source_divider>:
    }
    return status_success;
}

hpm_stat_t clock_set_source_divider(clock_name_t clock_name, clk_src_t src, uint32_t div)
{
80005ad8:	7179                	addi	sp,sp,-48
80005ada:	d606                	sw	ra,44(sp)
80005adc:	c62a                	sw	a0,12(sp)
80005ade:	87ae                	mv	a5,a1
80005ae0:	c232                	sw	a2,4(sp)
80005ae2:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
80005ae6:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
80005ae8:	47b2                	lw	a5,12(sp)
80005aea:	83a1                	srli	a5,a5,0x8
80005aec:	0ff7f793          	zext.b	a5,a5
80005af0:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
80005af2:	47b2                	lw	a5,12(sp)
80005af4:	0ff7f793          	zext.b	a5,a5
80005af8:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
80005afa:	4762                	lw	a4,24(sp)
80005afc:	47a9                	li	a5,10
80005afe:	08e7e563          	bltu	a5,a4,80005b88 <.L111>
80005b02:	47e2                	lw	a5,24(sp)
80005b04:	00279713          	slli	a4,a5,0x2
80005b08:	a7c18793          	addi	a5,gp,-1412 # 80003bb0 <.L113>
80005b0c:	97ba                	add	a5,a5,a4
80005b0e:	439c                	lw	a5,0(a5)
80005b10:	8782                	jr	a5

80005b12 <.L119>:
    case CLK_SRC_GROUP_COMMON:
        if ((div < 1U) || (div > 256U)) {
80005b12:	4792                	lw	a5,4(sp)
80005b14:	c791                	beqz	a5,80005b20 <.L120>
80005b16:	4712                	lw	a4,4(sp)
80005b18:	10000793          	li	a5,256
80005b1c:	00e7f763          	bgeu	a5,a4,80005b2a <.L121>

80005b20 <.L120>:
            status = status_clk_div_invalid;
80005b20:	6795                	lui	a5,0x5
80005b22:	5f078793          	addi	a5,a5,1520 # 55f0 <__HEAPSIZE__+0x15f0>
80005b26:	ce3e                	sw	a5,28(sp)
        } else {
            clock_source_t source = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, source, div);
        }
        break;
80005b28:	a0ad                	j	80005b92 <.L123>

80005b2a <.L121>:
            clock_source_t source = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
80005b2a:	00b14783          	lbu	a5,11(sp)
80005b2e:	8bbd                	andi	a5,a5,15
80005b30:	00f109a3          	sb	a5,19(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, source, div);
80005b34:	47d2                	lw	a5,20(sp)
80005b36:	0ff7f793          	zext.b	a5,a5
80005b3a:	01314703          	lbu	a4,19(sp)
80005b3e:	4692                	lw	a3,4(sp)
80005b40:	863a                	mv	a2,a4
80005b42:	85be                	mv	a1,a5
80005b44:	f4000537          	lui	a0,0xf4000
80005b48:	3e09                	jal	8000565a <sysctl_config_clock>

80005b4a <.LBE12>:
        break;
80005b4a:	a0a1                	j	80005b92 <.L123>

80005b4c <.L112>:
    case CLK_SRC_GROUP_ADC:
    case CLK_SRC_GROUP_EWDG:
    case CLK_SRC_GROUP_PEWDG:
    case CLK_SRC_GROUP_SRC:
        status = status_clk_operation_unsupported;
80005b4c:	6795                	lui	a5,0x5
80005b4e:	5f378793          	addi	a5,a5,1523 # 55f3 <__HEAPSIZE__+0x15f3>
80005b52:	ce3e                	sw	a5,28(sp)
        break;
80005b54:	a83d                	j	80005b92 <.L123>

80005b56 <.L115>:
    case CLK_SRC_GROUP_PMIC:
        status = status_clk_fixed;
80005b56:	6795                	lui	a5,0x5
80005b58:	5f978793          	addi	a5,a5,1529 # 55f9 <__HEAPSIZE__+0x15f9>
80005b5c:	ce3e                	sw	a5,28(sp)
        break;
80005b5e:	a815                	j	80005b92 <.L123>

80005b60 <.L118>:
    case CLK_SRC_GROUP_AHB:
        status = status_clk_shared_ahb;
80005b60:	6795                	lui	a5,0x5
80005b62:	5f478793          	addi	a5,a5,1524 # 55f4 <__HEAPSIZE__+0x15f4>
80005b66:	ce3e                	sw	a5,28(sp)
        break;
80005b68:	a02d                	j	80005b92 <.L123>

80005b6a <.L117>:
    case CLK_SRC_GROUP_AXIF:
        status = status_clk_shared_axif;
80005b6a:	6795                	lui	a5,0x5
80005b6c:	5f578793          	addi	a5,a5,1525 # 55f5 <__HEAPSIZE__+0x15f5>
80005b70:	ce3e                	sw	a5,28(sp)
        break;
80005b72:	a005                	j	80005b92 <.L123>

80005b74 <.L116>:
    case CLK_SRC_GROUP_AXIC:
        status = status_clk_shared_axic;
80005b74:	6795                	lui	a5,0x5
80005b76:	5f778793          	addi	a5,a5,1527 # 55f7 <__HEAPSIZE__+0x15f7>
80005b7a:	ce3e                	sw	a5,28(sp)
        break;
80005b7c:	a819                	j	80005b92 <.L123>

80005b7e <.L114>:
    case CLK_SRC_GROUP_CPU0:
        status = status_clk_shared_cpu0;
80005b7e:	6795                	lui	a5,0x5
80005b80:	5f878793          	addi	a5,a5,1528 # 55f8 <__HEAPSIZE__+0x15f8>
80005b84:	ce3e                	sw	a5,28(sp)
        break;
80005b86:	a031                	j	80005b92 <.L123>

80005b88 <.L111>:
    default:
        status = status_clk_src_invalid;
80005b88:	6795                	lui	a5,0x5
80005b8a:	5f178793          	addi	a5,a5,1521 # 55f1 <__HEAPSIZE__+0x15f1>
80005b8e:	ce3e                	sw	a5,28(sp)
        break;
80005b90:	0001                	nop

80005b92 <.L123>:
    }

    return status;
80005b92:	47f2                	lw	a5,28(sp)
}
80005b94:	853e                	mv	a0,a5
80005b96:	50b2                	lw	ra,44(sp)
80005b98:	6145                	addi	sp,sp,48
80005b9a:	8082                	ret

Disassembly of section .text.clock_add_to_group:

80005b9c <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
80005b9c:	7179                	addi	sp,sp,-48
80005b9e:	d606                	sw	ra,44(sp)
80005ba0:	c62a                	sw	a0,12(sp)
80005ba2:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
80005ba4:	47b2                	lw	a5,12(sp)
80005ba6:	83c1                	srli	a5,a5,0x10
80005ba8:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
80005baa:	4772                	lw	a4,28(sp)
80005bac:	14000793          	li	a5,320
80005bb0:	00e7ef63          	bltu	a5,a4,80005bce <.L134>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
80005bb4:	47a2                	lw	a5,8(sp)
80005bb6:	0ff7f793          	zext.b	a5,a5
80005bba:	4772                	lw	a4,28(sp)
80005bbc:	08074733          	zext.h	a4,a4
80005bc0:	4685                	li	a3,1
80005bc2:	863a                	mv	a2,a4
80005bc4:	85be                	mv	a1,a5
80005bc6:	f4000537          	lui	a0,0xf4000
80005bca:	2bd020ef          	jal	80008686 <sysctl_enable_group_resource>

80005bce <.L134>:
    }
}
80005bce:	0001                	nop
80005bd0:	50b2                	lw	ra,44(sp)
80005bd2:	6145                	addi	sp,sp,48
80005bd4:	8082                	ret

Disassembly of section .text.clock_cpu_delay_ms:

80005bd6 <clock_cpu_delay_ms>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_cpu_delay_ms(uint32_t ms)
{
80005bd6:	715d                	addi	sp,sp,-80
80005bd8:	c686                	sw	ra,76(sp)
80005bda:	c4a2                	sw	s0,72(sp)
80005bdc:	c2a6                	sw	s1,68(sp)
80005bde:	c0ca                	sw	s2,64(sp)
80005be0:	de4e                	sw	s3,60(sp)
80005be2:	dc52                	sw	s4,56(sp)
80005be4:	da56                	sw	s5,52(sp)
80005be6:	d85a                	sw	s6,48(sp)
80005be8:	d65e                	sw	s7,44(sp)
80005bea:	c62a                	sw	a0,12(sp)
    uint64_t expected_ticks = hpm_csr_get_core_cycle() + (uint64_t)clock_get_core_clock_ticks_per_ms() * (uint64_t)ms;
80005bec:	3cf5                	jal	800056e8 <hpm_csr_get_core_cycle>
80005bee:	8b2a                	mv	s6,a0
80005bf0:	8bae                	mv	s7,a1
80005bf2:	475020ef          	jal	80008866 <clock_get_core_clock_ticks_per_ms>
80005bf6:	87aa                	mv	a5,a0
80005bf8:	8a3e                	mv	s4,a5
80005bfa:	4a81                	li	s5,0
80005bfc:	47b2                	lw	a5,12(sp)
80005bfe:	893e                	mv	s2,a5
80005c00:	4981                	li	s3,0
80005c02:	032a8733          	mul	a4,s5,s2
80005c06:	034987b3          	mul	a5,s3,s4
80005c0a:	97ba                	add	a5,a5,a4
80005c0c:	032a0733          	mul	a4,s4,s2
80005c10:	032a34b3          	mulhu	s1,s4,s2
80005c14:	843a                	mv	s0,a4
80005c16:	97a6                	add	a5,a5,s1
80005c18:	84be                	mv	s1,a5
80005c1a:	008b0733          	add	a4,s6,s0
80005c1e:	86ba                	mv	a3,a4
80005c20:	0166b6b3          	sltu	a3,a3,s6
80005c24:	009b87b3          	add	a5,s7,s1
80005c28:	96be                	add	a3,a3,a5
80005c2a:	87b6                	mv	a5,a3
80005c2c:	cc3a                	sw	a4,24(sp)
80005c2e:	ce3e                	sw	a5,28(sp)
    while (hpm_csr_get_core_cycle() < expected_ticks) {
80005c30:	0001                	nop

80005c32 <.L158>:
80005c32:	3c5d                	jal	800056e8 <hpm_csr_get_core_cycle>
80005c34:	872a                	mv	a4,a0
80005c36:	87ae                	mv	a5,a1
80005c38:	46f2                	lw	a3,28(sp)
80005c3a:	863e                	mv	a2,a5
80005c3c:	fed66be3          	bltu	a2,a3,80005c32 <.L158>
80005c40:	46f2                	lw	a3,28(sp)
80005c42:	863e                	mv	a2,a5
80005c44:	00c69663          	bne	a3,a2,80005c50 <.L160>
80005c48:	46e2                	lw	a3,24(sp)
80005c4a:	87ba                	mv	a5,a4
80005c4c:	fed7e3e3          	bltu	a5,a3,80005c32 <.L158>

80005c50 <.L160>:
    }
}
80005c50:	0001                	nop
80005c52:	40b6                	lw	ra,76(sp)
80005c54:	4426                	lw	s0,72(sp)
80005c56:	4496                	lw	s1,68(sp)
80005c58:	4906                	lw	s2,64(sp)
80005c5a:	59f2                	lw	s3,60(sp)
80005c5c:	5a62                	lw	s4,56(sp)
80005c5e:	5ad2                	lw	s5,52(sp)
80005c60:	5b42                	lw	s6,48(sp)
80005c62:	5bb2                	lw	s7,44(sp)
80005c64:	6161                	addi	sp,sp,80
80005c66:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

80005c68 <l1c_dc_enable>:
    }
#endif
}

void l1c_dc_enable(void)
{
80005c68:	1101                	addi	sp,sp,-32
80005c6a:	ce06                	sw	ra,28(sp)

80005c6c <.LBB48>:
#endif

/* get cache control register value */
ATTR_ALWAYS_INLINE static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
80005c6c:	7ca027f3          	csrr	a5,0x7ca
80005c70:	c63e                	sw	a5,12(sp)
80005c72:	47b2                	lw	a5,12(sp)

80005c74 <.LBE52>:
80005c74:	0001                	nop

80005c76 <.LBE50>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
80005c76:	8b89                	andi	a5,a5,2
80005c78:	00f037b3          	snez	a5,a5
80005c7c:	0ff7f793          	zext.b	a5,a5

80005c80 <.LBE48>:
    if (!l1c_dc_is_enabled()) {
80005c80:	0017c793          	xori	a5,a5,1
80005c84:	0ff7f793          	zext.b	a5,a5
80005c88:	c791                	beqz	a5,80005c94 <.L11>
#ifdef L1C_DC_DISABLE_WRITEAROUND_ON_ENABLE
        l1c_dc_disable_writearound();
#else
        l1c_dc_enable_writearound();
80005c8a:	2081                	jal	80005cca <l1c_dc_enable_writearound>
#endif
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DPREF_EN_MASK | HPM_MCACHE_CTL_DC_EN_MASK);
80005c8c:	40200793          	li	a5,1026
80005c90:	7ca7a073          	csrs	0x7ca,a5

80005c94 <.L11>:
    }
}
80005c94:	0001                	nop
80005c96:	40f2                	lw	ra,28(sp)
80005c98:	6105                	addi	sp,sp,32
80005c9a:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

80005c9c <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
80005c9c:	1141                	addi	sp,sp,-16

80005c9e <.LBB58>:
    return read_csr(CSR_MCACHE_CTL);
80005c9e:	7ca027f3          	csrr	a5,0x7ca
80005ca2:	c63e                	sw	a5,12(sp)
80005ca4:	47b2                	lw	a5,12(sp)

80005ca6 <.LBE62>:
80005ca6:	0001                	nop

80005ca8 <.LBE60>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
80005ca8:	8b85                	andi	a5,a5,1
80005caa:	00f037b3          	snez	a5,a5
80005cae:	0ff7f793          	zext.b	a5,a5

80005cb2 <.LBE58>:
    if (!l1c_ic_is_enabled()) {
80005cb2:	0017c793          	xori	a5,a5,1
80005cb6:	0ff7f793          	zext.b	a5,a5
80005cba:	c789                	beqz	a5,80005cc4 <.L21>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
80005cbc:	30100793          	li	a5,769
80005cc0:	7ca7a073          	csrs	0x7ca,a5

80005cc4 <.L21>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
80005cc4:	0001                	nop
80005cc6:	0141                	addi	sp,sp,16
80005cc8:	8082                	ret

Disassembly of section .text.l1c_dc_enable_writearound:

80005cca <l1c_dc_enable_writearound>:
    l1c_op(HPM_L1C_CCTL_CMD_L1I_VA_UNLOCK, address, size);
}

void l1c_dc_enable_writearound(void)
{
    set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
80005cca:	6799                	lui	a5,0x6
80005ccc:	7ca7a073          	csrs	0x7ca,a5
}
80005cd0:	0001                	nop
80005cd2:	8082                	ret

Disassembly of section .text.init_gpio_pins:

80005cd4 <init_gpio_pins>:
{
    HPM_IOC->PAD[IOC_PAD_PF15].FUNC_CTL = IOC_PF15_FUNC_CTL_PWM1_P_7;
}

void init_gpio_pins(void)
{
80005cd4:	1141                	addi	sp,sp,-16
    /* configure pad setting: pull enable and pull down, schmitt trigger enable */
    /* enable schmitt trigger to eliminate jitter of pin used as button */

    uint32_t pad_ctl = IOC_PAD_PAD_CTL_PE_SET(1) | IOC_PAD_PAD_CTL_PS_SET(0) | IOC_PAD_PAD_CTL_HYS_SET(1);
80005cd6:	010207b7          	lui	a5,0x1020
80005cda:	c63e                	sw	a5,12(sp)

    /* LED */
    HPM_IOC->PAD[IOC_PAD_PA22].FUNC_CTL = IOC_PA22_FUNC_CTL_GPIO_A_22;
80005cdc:	f40407b7          	lui	a5,0xf4040
80005ce0:	0a07a823          	sw	zero,176(a5) # f40400b0 <__AHB_SRAM_segment_end__+0x3e380b0>

    /* KEYA */
    HPM_IOC->PAD[IOC_PAD_PA02].FUNC_CTL = IOC_PA02_FUNC_CTL_GPIO_A_02;
80005ce4:	f40407b7          	lui	a5,0xf4040
80005ce8:	0007a823          	sw	zero,16(a5) # f4040010 <__AHB_SRAM_segment_end__+0x3e38010>
    HPM_IOC->PAD[IOC_PAD_PA02].PAD_CTL = pad_ctl;
80005cec:	f40407b7          	lui	a5,0xf4040
80005cf0:	4732                	lw	a4,12(sp)
80005cf2:	cbd8                	sw	a4,20(a5)

    /* KEYB */
    HPM_IOC->PAD[IOC_PAD_PA03].FUNC_CTL = IOC_PA03_FUNC_CTL_GPIO_A_03;
80005cf4:	f40407b7          	lui	a5,0xf4040
80005cf8:	0007ac23          	sw	zero,24(a5) # f4040018 <__AHB_SRAM_segment_end__+0x3e38018>
    HPM_IOC->PAD[IOC_PAD_PA03].PAD_CTL = pad_ctl;
80005cfc:	f40407b7          	lui	a5,0xf4040
80005d00:	4732                	lw	a4,12(sp)
80005d02:	cfd8                	sw	a4,28(a5)
}
80005d04:	0001                	nop
80005d06:	0141                	addi	sp,sp,16
80005d08:	8082                	ret

Disassembly of section .text.sysctl_clock_set_preset:

80005d0a <sysctl_clock_set_preset>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] preset preset
 */
static inline void sysctl_clock_set_preset(SYSCTL_Type *ptr, sysctl_preset_t preset)
{
80005d0a:	1141                	addi	sp,sp,-16
80005d0c:	c62a                	sw	a0,12(sp)
80005d0e:	87ae                	mv	a5,a1
80005d10:	00f105a3          	sb	a5,11(sp)
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_MUX_MASK) | SYSCTL_GLOBAL00_MUX_SET(preset);
80005d14:	4732                	lw	a4,12(sp)
80005d16:	6789                	lui	a5,0x2
80005d18:	97ba                	add	a5,a5,a4
80005d1a:	439c                	lw	a5,0(a5)
80005d1c:	f007f713          	andi	a4,a5,-256
80005d20:	00b14783          	lbu	a5,11(sp)
80005d24:	8f5d                	or	a4,a4,a5
80005d26:	46b2                	lw	a3,12(sp)
80005d28:	6789                	lui	a5,0x2
80005d2a:	97b6                	add	a5,a5,a3
80005d2c:	c398                	sw	a4,0(a5)
}
80005d2e:	0001                	nop
80005d30:	0141                	addi	sp,sp,16
80005d32:	8082                	ret

Disassembly of section .text.pllctlv2_xtal_set_rampup_time:

80005d34 <pllctlv2_xtal_set_rampup_time>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] rc24m_cycles Number of RC24M clock cycles for the ramp-up period
 * @note The ramp-up time affects how quickly the crystal oscillator reaches stable operation
 */
static inline void pllctlv2_xtal_set_rampup_time(PLLCTLV2_Type *ptr, uint32_t rc24m_cycles)
{
80005d34:	1141                	addi	sp,sp,-16
80005d36:	c62a                	sw	a0,12(sp)
80005d38:	c42e                	sw	a1,8(sp)
    ptr->XTAL = (ptr->XTAL & ~PLLCTLV2_XTAL_RAMP_TIME_MASK) | PLLCTLV2_XTAL_RAMP_TIME_SET(rc24m_cycles);
80005d3a:	47b2                	lw	a5,12(sp)
80005d3c:	4398                	lw	a4,0(a5)
80005d3e:	fff007b7          	lui	a5,0xfff00
80005d42:	8f7d                	and	a4,a4,a5
80005d44:	46a2                	lw	a3,8(sp)
80005d46:	001007b7          	lui	a5,0x100
80005d4a:	17fd                	addi	a5,a5,-1 # fffff <__FLASH_segment_size__+0x2fff>
80005d4c:	8ff5                	and	a5,a5,a3
80005d4e:	8f5d                	or	a4,a4,a5
80005d50:	47b2                	lw	a5,12(sp)
80005d52:	c398                	sw	a4,0(a5)
}
80005d54:	0001                	nop
80005d56:	0141                	addi	sp,sp,16
80005d58:	8082                	ret

Disassembly of section .text.board_init_console:

80005d5a <board_init_console>:
#if defined(FLASH_UF2) && FLASH_UF2
ATTR_PLACE_AT(".uf2_signature") __attribute__((used)) const uint32_t uf2_signature = BOARD_UF2_SIGNATURE;
#endif

void board_init_console(void)
{
80005d5a:	1101                	addi	sp,sp,-32
80005d5c:	ce06                	sw	ra,28(sp)

    /* uart needs to configure pin function before enabling clock, otherwise the level change of
     * uart rx pin when configuring pin function will cause a wrong data to be received.
     * And a uart rx dma request will be generated by default uart fifo dma trigger level.
     */
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
80005d5e:	f004c537          	lui	a0,0xf004c
80005d62:	36b020ef          	jal	800088cc <init_uart_pins>

    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
80005d66:	4581                	li	a1,0
80005d68:	011907b7          	lui	a5,0x1190
80005d6c:	01778513          	addi	a0,a5,23 # 1190017 <__DLM_segment_end__+0xf70017>
80005d70:	3535                	jal	80005b9c <clock_add_to_group>

    cfg.type = BOARD_CONSOLE_TYPE;
80005d72:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t) BOARD_CONSOLE_UART_BASE;
80005d74:	f004c7b7          	lui	a5,0xf004c
80005d78:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
80005d7a:	011907b7          	lui	a5,0x1190
80005d7e:	01778513          	addi	a0,a5,23 # 1190017 <__DLM_segment_end__+0xf70017>
80005d82:	32c5                	jal	80005762 <clock_get_frequency>
80005d84:	87aa                	mv	a5,a0
80005d86:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
80005d88:	001197b7          	lui	a5,0x119
80005d8c:	40078793          	addi	a5,a5,1024 # 119400 <_flash_size+0x19400>
80005d90:	c63e                	sw	a5,12(sp)

    if (status_success != console_init(&cfg)) {
80005d92:	878a                	mv	a5,sp
80005d94:	853e                	mv	a0,a5
80005d96:	7eb030ef          	jal	80009d80 <console_init>
80005d9a:	87aa                	mv	a5,a0
80005d9c:	c391                	beqz	a5,80005da0 <.L39>

80005d9e <.L38>:
        /* failed to  initialize debug console */
        while (1) {
80005d9e:	a001                	j	80005d9e <.L38>

80005da0 <.L39>:
#else
    while (1)
        ;
#endif
#endif
}
80005da0:	0001                	nop
80005da2:	40f2                	lw	ra,28(sp)
80005da4:	6105                	addi	sp,sp,32
80005da6:	8082                	ret

Disassembly of section .text.board_print_banner:

80005da8 <board_print_banner>:
    init_uart_pins(ptr);
    board_init_uart_clock(ptr);
}

void board_print_banner(void)
{
80005da8:	d8010113          	addi	sp,sp,-640
80005dac:	26112e23          	sw	ra,636(sp)
    const uint8_t banner[] = { "\n\
80005db0:	ea018713          	addi	a4,gp,-352 # 80003fd4 <.LC10>
80005db4:	878a                	mv	a5,sp
80005db6:	86ba                	mv	a3,a4
80005db8:	26f00713          	li	a4,623
80005dbc:	863a                	mv	a2,a4
80005dbe:	85b6                	mv	a1,a3
80005dc0:	853e                	mv	a0,a5
80005dc2:	076010ef          	jal	80006e38 <memcpy>
\\__|  \\__|\\__|      \\__|     \\__|\\__| \\_______|\\__|       \\______/\n\
----------------------------------------------------------------------\n" };
#ifdef SDK_VERSION_STRING
    printf("hpm_sdk: %s\n", SDK_VERSION_STRING);
#endif
    printf("%s", banner);
80005dc6:	878a                	mv	a5,sp
80005dc8:	85be                	mv	a1,a5
80005dca:	e9c18513          	addi	a0,gp,-356 # 80003fd0 <.LC11>
80005dce:	33c010ef          	jal	8000710a <printf>
}
80005dd2:	0001                	nop
80005dd4:	27c12083          	lw	ra,636(sp)
80005dd8:	28010113          	addi	sp,sp,640
80005ddc:	8082                	ret

Disassembly of section .text.board_get_led_gpio_off_level:

80005dde <board_get_led_gpio_off_level>:

uint8_t board_get_led_gpio_off_level(void)
{
    return BOARD_LED_OFF_LEVEL;
80005dde:	4785                	li	a5,1
}
80005de0:	853e                	mv	a0,a5
80005de2:	8082                	ret

Disassembly of section .text.board_init_adc_clock:

80005de4 <board_init_adc_clock>:
{
    init_adc16_pins();
}

uint32_t board_init_adc_clock(void *ptr, bool clk_src_bus)  /* motor system should be use clk_adc_src_ahb0 */
{
80005de4:	7179                	addi	sp,sp,-48
80005de6:	d606                	sw	ra,44(sp)
80005de8:	c62a                	sw	a0,12(sp)
80005dea:	87ae                	mv	a5,a1
80005dec:	00f105a3          	sb	a5,11(sp)
    uint32_t freq = 0;
80005df0:	ce02                	sw	zero,28(sp)

    if (ptr == (void *)HPM_ADC0) {
80005df2:	4732                	lw	a4,12(sp)
80005df4:	f01007b7          	lui	a5,0xf0100
80005df8:	02f71f63          	bne	a4,a5,80005e36 <.L96>
        clock_add_to_group(clock_adc0, 0);
80005dfc:	4581                	li	a1,0
80005dfe:	012707b7          	lui	a5,0x1270
80005e02:	10078513          	addi	a0,a5,256 # 1270100 <__NONCACHEABLE_RAM_segment_end__+0x30100>
80005e06:	3b59                	jal	80005b9c <clock_add_to_group>
        if (clk_src_bus) {
80005e08:	00b14783          	lbu	a5,11(sp)
80005e0c:	cb81                	beqz	a5,80005e1c <.L97>
            /* Configure the ADC clock from AHB (@200MHz by default)*/
            clock_set_adc_source(clock_adc0, clk_adc_src_ahb0);
80005e0e:	45c1                	li	a1,16
80005e10:	012707b7          	lui	a5,0x1270
80005e14:	10078513          	addi	a0,a5,256 # 1270100 <__NONCACHEABLE_RAM_segment_end__+0x30100>
80005e18:	390d                	jal	80005a4a <clock_set_adc_source>
80005e1a:	a039                	j	80005e28 <.L98>

80005e1c <.L97>:
        } else {
            /* Configure the ADC clock from ANA (@200MHz by default)*/
            clock_set_adc_source(clock_adc0, clk_adc_src_ana0);
80005e1c:	45c5                	li	a1,17
80005e1e:	012707b7          	lui	a5,0x1270
80005e22:	10078513          	addi	a0,a5,256 # 1270100 <__NONCACHEABLE_RAM_segment_end__+0x30100>
80005e26:	3115                	jal	80005a4a <clock_set_adc_source>

80005e28 <.L98>:
        }
        freq = clock_get_frequency(clock_adc0);
80005e28:	012707b7          	lui	a5,0x1270
80005e2c:	10078513          	addi	a0,a5,256 # 1270100 <__NONCACHEABLE_RAM_segment_end__+0x30100>
80005e30:	3a0d                	jal	80005762 <clock_get_frequency>
80005e32:	ce2a                	sw	a0,28(sp)
80005e34:	a091                	j	80005e78 <.L99>

80005e36 <.L96>:
    } else if (ptr == (void *)HPM_ADC1) {
80005e36:	4732                	lw	a4,12(sp)
80005e38:	f01047b7          	lui	a5,0xf0104
80005e3c:	02f71e63          	bne	a4,a5,80005e78 <.L99>
        clock_add_to_group(clock_adc1, 0);
80005e40:	4581                	li	a1,0
80005e42:	012807b7          	lui	a5,0x1280
80005e46:	10178513          	addi	a0,a5,257 # 1280101 <__NONCACHEABLE_RAM_segment_end__+0x40101>
80005e4a:	3b89                	jal	80005b9c <clock_add_to_group>
        if (clk_src_bus) {
80005e4c:	00b14783          	lbu	a5,11(sp)
80005e50:	cb81                	beqz	a5,80005e60 <.L100>
            /* Configure the ADC clock from AHB (@200MHz by default)*/
            clock_set_adc_source(clock_adc1, clk_adc_src_ahb0);
80005e52:	45c1                	li	a1,16
80005e54:	012807b7          	lui	a5,0x1280
80005e58:	10178513          	addi	a0,a5,257 # 1280101 <__NONCACHEABLE_RAM_segment_end__+0x40101>
80005e5c:	36fd                	jal	80005a4a <clock_set_adc_source>
80005e5e:	a039                	j	80005e6c <.L101>

80005e60 <.L100>:
        } else {
            /* Configure the ADC clock from ANA (@200MHz by default)*/
            clock_set_adc_source(clock_adc1, clk_adc_src_ana1);
80005e60:	45c5                	li	a1,17
80005e62:	012807b7          	lui	a5,0x1280
80005e66:	10178513          	addi	a0,a5,257 # 1280101 <__NONCACHEABLE_RAM_segment_end__+0x40101>
80005e6a:	36c5                	jal	80005a4a <clock_set_adc_source>

80005e6c <.L101>:
        }
        freq = clock_get_frequency(clock_adc1);
80005e6c:	012807b7          	lui	a5,0x1280
80005e70:	10178513          	addi	a0,a5,257 # 1280101 <__NONCACHEABLE_RAM_segment_end__+0x40101>
80005e74:	30fd                	jal	80005762 <clock_get_frequency>
80005e76:	ce2a                	sw	a0,28(sp)

80005e78 <.L99>:
    } else {
        ;
    }

    return freq;
80005e78:	47f2                	lw	a5,28(sp)
}
80005e7a:	853e                	mv	a0,a5
80005e7c:	50b2                	lw	ra,44(sp)
80005e7e:	6145                	addi	sp,sp,48
80005e80:	8082                	ret

Disassembly of section .text.uart_init:

80005e82 <uart_init>:
    }
    return false;
}

hpm_stat_t uart_init(UART_Type *ptr, uart_config_t *config)
{
80005e82:	7179                	addi	sp,sp,-48
80005e84:	d606                	sw	ra,44(sp)
80005e86:	c62a                	sw	a0,12(sp)
80005e88:	c42e                	sw	a1,8(sp)
    uint32_t tmp;
    uint8_t osc;
    uint16_t div;

    /* disable all interrupts */
    ptr->IER = 0;
80005e8a:	47b2                	lw	a5,12(sp)
80005e8c:	0207a223          	sw	zero,36(a5)
    /* Set DLAB to 1 */
    ptr->LCR |= UART_LCR_DLAB_MASK;
80005e90:	47b2                	lw	a5,12(sp)
80005e92:	57dc                	lw	a5,44(a5)
80005e94:	0807e713          	ori	a4,a5,128
80005e98:	47b2                	lw	a5,12(sp)
80005e9a:	d7d8                	sw	a4,44(a5)

    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
80005e9c:	47a2                	lw	a5,8(sp)
80005e9e:	4398                	lw	a4,0(a5)
80005ea0:	47a2                	lw	a5,8(sp)
80005ea2:	43dc                	lw	a5,4(a5)
80005ea4:	01b10693          	addi	a3,sp,27
80005ea8:	0830                	addi	a2,sp,24
80005eaa:	85be                	mv	a1,a5
80005eac:	853a                	mv	a0,a4
80005eae:	0b8030ef          	jal	80008f66 <uart_calculate_baudrate>
80005eb2:	87aa                	mv	a5,a0
80005eb4:	0017c793          	xori	a5,a5,1
80005eb8:	0ff7f793          	zext.b	a5,a5
80005ebc:	c781                	beqz	a5,80005ec4 <.L27>
        return status_uart_no_suitable_baudrate_parameter_found;
80005ebe:	3e900793          	li	a5,1001
80005ec2:	a251                	j	80006046 <.L44>

80005ec4 <.L27>:
    }
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80005ec4:	47b2                	lw	a5,12(sp)
80005ec6:	4bdc                	lw	a5,20(a5)
80005ec8:	fe07f713          	andi	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
80005ecc:	01b14783          	lbu	a5,27(sp)
80005ed0:	8bfd                	andi	a5,a5,31
80005ed2:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
80005ed4:	47b2                	lw	a5,12(sp)
80005ed6:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
80005ed8:	01815783          	lhu	a5,24(sp)
80005edc:	0ff7f713          	zext.b	a4,a5
80005ee0:	47b2                	lw	a5,12(sp)
80005ee2:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
80005ee4:	01815783          	lhu	a5,24(sp)
80005ee8:	83a1                	srli	a5,a5,0x8
80005eea:	0807c7b3          	zext.h	a5,a5
80005eee:	0ff7f713          	zext.b	a4,a5
80005ef2:	47b2                	lw	a5,12(sp)
80005ef4:	d3d8                	sw	a4,36(a5)

    /* DLAB bit needs to be cleared once baudrate is configured */
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
80005ef6:	47b2                	lw	a5,12(sp)
80005ef8:	57dc                	lw	a5,44(a5)
80005efa:	f7f7f793          	andi	a5,a5,-129
80005efe:	ce3e                	sw	a5,28(sp)

    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
80005f00:	47f2                	lw	a5,28(sp)
80005f02:	fc77f793          	andi	a5,a5,-57
80005f06:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
80005f08:	47a2                	lw	a5,8(sp)
80005f0a:	00a7c783          	lbu	a5,10(a5)
80005f0e:	4711                	li	a4,4
80005f10:	02f76d63          	bltu	a4,a5,80005f4a <.L29>
80005f14:	00279713          	slli	a4,a5,0x2
80005f18:	aa818793          	addi	a5,gp,-1368 # 80003bdc <.L31>
80005f1c:	97ba                	add	a5,a5,a4
80005f1e:	439c                	lw	a5,0(a5)
80005f20:	8782                	jr	a5

80005f22 <.L34>:
    case parity_none:
        break;
    case parity_odd:
        tmp |= UART_LCR_PEN_MASK;
80005f22:	47f2                	lw	a5,28(sp)
80005f24:	0087e793          	ori	a5,a5,8
80005f28:	ce3e                	sw	a5,28(sp)
        break;
80005f2a:	a01d                	j	80005f50 <.L36>

80005f2c <.L33>:
    case parity_even:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
80005f2c:	47f2                	lw	a5,28(sp)
80005f2e:	0187e793          	ori	a5,a5,24
80005f32:	ce3e                	sw	a5,28(sp)
        break;
80005f34:	a831                	j	80005f50 <.L36>

80005f36 <.L32>:
    case parity_always_1:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
80005f36:	47f2                	lw	a5,28(sp)
80005f38:	0287e793          	ori	a5,a5,40
80005f3c:	ce3e                	sw	a5,28(sp)
        break;
80005f3e:	a809                	j	80005f50 <.L36>

80005f40 <.L30>:
    case parity_always_0:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
80005f40:	47f2                	lw	a5,28(sp)
80005f42:	0387e793          	ori	a5,a5,56
80005f46:	ce3e                	sw	a5,28(sp)
            | UART_LCR_SPS_MASK;
        break;
80005f48:	a021                	j	80005f50 <.L36>

80005f4a <.L29>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
80005f4a:	4789                	li	a5,2
80005f4c:	a8ed                	j	80006046 <.L44>

80005f4e <.L45>:
        break;
80005f4e:	0001                	nop

80005f50 <.L36>:
    }

    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
80005f50:	47f2                	lw	a5,28(sp)
80005f52:	9be1                	andi	a5,a5,-8
80005f54:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
80005f56:	47a2                	lw	a5,8(sp)
80005f58:	0087c783          	lbu	a5,8(a5)
80005f5c:	4709                	li	a4,2
80005f5e:	00e78e63          	beq	a5,a4,80005f7a <.L37>
80005f62:	4709                	li	a4,2
80005f64:	02f74663          	blt	a4,a5,80005f90 <.L38>
80005f68:	c795                	beqz	a5,80005f94 <.L46>
80005f6a:	4705                	li	a4,1
80005f6c:	02e79263          	bne	a5,a4,80005f90 <.L38>
    case stop_bits_1:
        break;
    case stop_bits_1_5:
        tmp |= UART_LCR_STB_MASK;
80005f70:	47f2                	lw	a5,28(sp)
80005f72:	0047e793          	ori	a5,a5,4
80005f76:	ce3e                	sw	a5,28(sp)
        break;
80005f78:	a839                	j	80005f96 <.L41>

80005f7a <.L37>:
    case stop_bits_2:
        if (config->word_length < word_length_6_bits) {
80005f7a:	47a2                	lw	a5,8(sp)
80005f7c:	0097c783          	lbu	a5,9(a5)
80005f80:	e399                	bnez	a5,80005f86 <.L42>
            /* invalid configuration */
            return status_invalid_argument;
80005f82:	4789                	li	a5,2
80005f84:	a0c9                	j	80006046 <.L44>

80005f86 <.L42>:
        }
        tmp |= UART_LCR_STB_MASK;
80005f86:	47f2                	lw	a5,28(sp)
80005f88:	0047e793          	ori	a5,a5,4
80005f8c:	ce3e                	sw	a5,28(sp)
        break;
80005f8e:	a021                	j	80005f96 <.L41>

80005f90 <.L38>:
    default:
        /* invalid configuration */
        return status_invalid_argument;
80005f90:	4789                	li	a5,2
80005f92:	a855                	j	80006046 <.L44>

80005f94 <.L46>:
        break;
80005f94:	0001                	nop

80005f96 <.L41>:
    }

    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
80005f96:	47a2                	lw	a5,8(sp)
80005f98:	0097c783          	lbu	a5,9(a5)
80005f9c:	0037f713          	andi	a4,a5,3
80005fa0:	47f2                	lw	a5,28(sp)
80005fa2:	8f5d                	or	a4,a4,a5
80005fa4:	47b2                	lw	a5,12(sp)
80005fa6:	d7d8                	sw	a4,44(a5)

#if defined(HPM_IP_FEATURE_UART_FINE_FIFO_THRLD) && (HPM_IP_FEATURE_UART_FINE_FIFO_THRLD == 1)
    /* reset TX and RX fifo */
    ptr->FCRR = UART_FCRR_TFIFORST_MASK | UART_FCRR_RFIFORST_MASK;
80005fa8:	47b2                	lw	a5,12(sp)
80005faa:	4719                	li	a4,6
80005fac:	cf98                	sw	a4,24(a5)
    /* Enable FIFO */
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
        | UART_FCRR_FIFOE_SET(config->fifo_enable)
80005fae:	47a2                	lw	a5,8(sp)
80005fb0:	00e7c783          	lbu	a5,14(a5)
80005fb4:	86be                	mv	a3,a5
        | UART_FCRR_TFIFOT4_SET(config->tx_fifo_level)
80005fb6:	47a2                	lw	a5,8(sp)
80005fb8:	00b7c783          	lbu	a5,11(a5)
80005fbc:	01079713          	slli	a4,a5,0x10
80005fc0:	001f07b7          	lui	a5,0x1f0
80005fc4:	8ff9                	and	a5,a5,a4
80005fc6:	00f6e733          	or	a4,a3,a5
        | UART_FCRR_RFIFOT4_SET(config->rx_fifo_level)
80005fca:	47a2                	lw	a5,8(sp)
80005fcc:	00c7c783          	lbu	a5,12(a5) # 1f000c <_flash_size+0xf000c>
80005fd0:	00879693          	slli	a3,a5,0x8
80005fd4:	6789                	lui	a5,0x2
80005fd6:	f0078793          	addi	a5,a5,-256 # 1f00 <__NONCACHEABLE_RAM_segment_used_size__+0xe40>
80005fda:	8ff5                	and	a5,a5,a3
80005fdc:	8f5d                	or	a4,a4,a5
#if defined(HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT) && (HPM_IP_FEATURE_UART_DISABLE_DMA_TIMEOUT == 1)
        | UART_FCRR_TMOUT_RXDMA_DIS_MASK /**< disable RX timeout trigger dma */
#endif
        | UART_FCRR_DMAE_SET(config->dma_enable);
80005fde:	47a2                	lw	a5,8(sp)
80005fe0:	00d7c783          	lbu	a5,13(a5)
80005fe4:	078e                	slli	a5,a5,0x3
80005fe6:	8ba1                	andi	a5,a5,8
80005fe8:	8f5d                	or	a4,a4,a5
80005fea:	018007b7          	lui	a5,0x1800
80005fee:	8f5d                	or	a4,a4,a5
    ptr->FCRR = UART_FCRR_FIFOT4EN_MASK
80005ff0:	47b2                	lw	a5,12(sp)
80005ff2:	cf98                	sw	a4,24(a5)
    ptr->FCR = tmp;
    /* store FCR register value */
    ptr->GPR = tmp;
#endif

    uart_modem_config(ptr, &config->modem_config);
80005ff4:	47a2                	lw	a5,8(sp)
80005ff6:	07bd                	addi	a5,a5,15 # 180000f <__NONCACHEABLE_RAM_segment_end__+0x5c000f>
80005ff8:	85be                	mv	a1,a5
80005ffa:	4532                	lw	a0,12(sp)
80005ffc:	667020ef          	jal	80008e62 <uart_modem_config>

#if defined(HPM_IP_FEATURE_UART_RX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_RX_IDLE_DETECT == 1)
    uart_init_rxline_idle_detection(ptr, config->rxidle_config);
80006000:	47a2                	lw	a5,8(sp)
80006002:	0127d703          	lhu	a4,18(a5)
80006006:	0147d783          	lhu	a5,20(a5)
8000600a:	07c2                	slli	a5,a5,0x10
8000600c:	8fd9                	or	a5,a5,a4
8000600e:	873e                	mv	a4,a5
80006010:	85ba                	mv	a1,a4
80006012:	4532                	lw	a0,12(sp)
80006014:	1f6030ef          	jal	8000920a <uart_init_rxline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
    uart_init_txline_idle_detection(ptr, config->txidle_config);
80006018:	47a2                	lw	a5,8(sp)
8000601a:	0167d703          	lhu	a4,22(a5)
8000601e:	0187d783          	lhu	a5,24(a5)
80006022:	07c2                	slli	a5,a5,0x10
80006024:	8fd9                	or	a5,a5,a4
80006026:	873e                	mv	a4,a5
80006028:	85ba                	mv	a1,a4
8000602a:	4532                	lw	a0,12(sp)
8000602c:	2885                	jal	8000609c <uart_init_txline_idle_detection>
#endif

#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    if (config->rx_enable) {
8000602e:	47a2                	lw	a5,8(sp)
80006030:	01a7c783          	lbu	a5,26(a5)
80006034:	cb81                	beqz	a5,80006044 <.L43>
        ptr->IDLE_CFG |= UART_IDLE_CFG_RXEN_MASK;
80006036:	47b2                	lw	a5,12(sp)
80006038:	43d8                	lw	a4,4(a5)
8000603a:	28b01793          	bseti	a5,zero,0xb
8000603e:	8f5d                	or	a4,a4,a5
80006040:	47b2                	lw	a5,12(sp)
80006042:	c3d8                	sw	a4,4(a5)

80006044 <.L43>:
    }
#endif
    return status_success;
80006044:	4781                	li	a5,0

80006046 <.L44>:
}
80006046:	853e                	mv	a0,a5
80006048:	50b2                	lw	ra,44(sp)
8000604a:	6145                	addi	sp,sp,48
8000604c:	8082                	ret

Disassembly of section .text.uart_send_byte:

8000604e <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
8000604e:	1101                	addi	sp,sp,-32
80006050:	c62a                	sw	a0,12(sp)
80006052:	87ae                	mv	a5,a1
80006054:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
80006058:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
8000605a:	a811                	j	8000606e <.L52>

8000605c <.L55>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000605c:	4772                	lw	a4,28(sp)
8000605e:	6785                	lui	a5,0x1
80006060:	38878793          	addi	a5,a5,904 # 1388 <__NONCACHEABLE_RAM_segment_used_size__+0x2c8>
80006064:	00e7eb63          	bltu	a5,a4,8000607a <.L58>
            break;
        }
        retry++;
80006068:	47f2                	lw	a5,28(sp)
8000606a:	0785                	addi	a5,a5,1
8000606c:	ce3e                	sw	a5,28(sp)

8000606e <.L52>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
8000606e:	47b2                	lw	a5,12(sp)
80006070:	5bdc                	lw	a5,52(a5)
80006072:	0207f793          	andi	a5,a5,32
80006076:	d3fd                	beqz	a5,8000605c <.L55>
80006078:	a011                	j	8000607c <.L54>

8000607a <.L58>:
            break;
8000607a:	0001                	nop

8000607c <.L54>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000607c:	4772                	lw	a4,28(sp)
8000607e:	6785                	lui	a5,0x1
80006080:	38878793          	addi	a5,a5,904 # 1388 <__NONCACHEABLE_RAM_segment_used_size__+0x2c8>
80006084:	00e7f463          	bgeu	a5,a4,8000608c <.L56>
        return status_timeout;
80006088:	478d                	li	a5,3
8000608a:	a031                	j	80006096 <.L57>

8000608c <.L56>:
    }

    ptr->THR = UART_THR_THR_SET(c);
8000608c:	00b14703          	lbu	a4,11(sp)
80006090:	47b2                	lw	a5,12(sp)
80006092:	d398                	sw	a4,32(a5)
    return status_success;
80006094:	4781                	li	a5,0

80006096 <.L57>:
}
80006096:	853e                	mv	a0,a5
80006098:	6105                	addi	sp,sp,32
8000609a:	8082                	ret

Disassembly of section .text.uart_init_txline_idle_detection:

8000609c <uart_init_txline_idle_detection>:
}
#endif

#if defined(HPM_IP_FEATURE_UART_TX_IDLE_DETECT) && (HPM_IP_FEATURE_UART_TX_IDLE_DETECT == 1)
hpm_stat_t uart_init_txline_idle_detection(UART_Type *ptr, uart_rxline_idle_config_t txidle_config)
{
8000609c:	1101                	addi	sp,sp,-32
8000609e:	ce06                	sw	ra,28(sp)
800060a0:	c62a                	sw	a0,12(sp)
800060a2:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_TX_IDLE_EN_MASK
800060a4:	47b2                	lw	a5,12(sp)
800060a6:	43d8                	lw	a4,4(a5)
800060a8:	fc0107b7          	lui	a5,0xfc010
800060ac:	17fd                	addi	a5,a5,-1 # fc00ffff <__AHB_SRAM_segment_end__+0xbe07fff>
800060ae:	8f7d                	and	a4,a4,a5
800060b0:	47b2                	lw	a5,12(sp)
800060b2:	c3d8                	sw	a4,4(a5)
                    | UART_IDLE_CFG_TX_IDLE_THR_MASK
                    | UART_IDLE_CFG_TX_IDLE_COND_MASK);
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
800060b4:	47b2                	lw	a5,12(sp)
800060b6:	43d8                	lw	a4,4(a5)
800060b8:	00814783          	lbu	a5,8(sp)
800060bc:	01879693          	slli	a3,a5,0x18
800060c0:	010007b7          	lui	a5,0x1000
800060c4:	8efd                	and	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_THR_SET(txidle_config.threshold)
800060c6:	00b14783          	lbu	a5,11(sp)
800060ca:	01079613          	slli	a2,a5,0x10
800060ce:	00ff07b7          	lui	a5,0xff0
800060d2:	8ff1                	and	a5,a5,a2
800060d4:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_TX_IDLE_COND_SET(txidle_config.idle_cond);
800060d6:	00a14783          	lbu	a5,10(sp)
800060da:	01979613          	slli	a2,a5,0x19
800060de:	020007b7          	lui	a5,0x2000
800060e2:	8ff1                	and	a5,a5,a2
800060e4:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_TX_IDLE_EN_SET(txidle_config.detect_enable)
800060e6:	8f5d                	or	a4,a4,a5
800060e8:	47b2                	lw	a5,12(sp)
800060ea:	c3d8                	sw	a4,4(a5)

    if (txidle_config.detect_irq_enable) {
800060ec:	00914783          	lbu	a5,9(sp)
800060f0:	c799                	beqz	a5,800060fe <.L97>
        uart_enable_irq(ptr, uart_intr_tx_line_idle);
800060f2:	400005b7          	lui	a1,0x40000
800060f6:	4532                	lw	a0,12(sp)
800060f8:	5c3020ef          	jal	80008eba <uart_enable_irq>
800060fc:	a031                	j	80006108 <.L98>

800060fe <.L97>:
    } else {
        uart_disable_irq(ptr, uart_intr_tx_line_idle);
800060fe:	400005b7          	lui	a1,0x40000
80006102:	4532                	lw	a0,12(sp)
80006104:	59b020ef          	jal	80008e9e <uart_disable_irq>

80006108 <.L98>:
    }

    return status_success;
80006108:	4781                	li	a5,0
}
8000610a:	853e                	mv	a0,a5
8000610c:	40f2                	lw	ra,28(sp)
8000610e:	6105                	addi	sp,sp,32
80006110:	8082                	ret

Disassembly of section .text.read_pmp_cfg:

80006112 <read_pmp_cfg>:

#define PMP_ENTRY_MAX 16
#define PMA_ENTRY_MAX 16

uint32_t read_pmp_cfg(uint32_t idx)
{
80006112:	7179                	addi	sp,sp,-48
80006114:	c62a                	sw	a0,12(sp)
    uint32_t pmp_cfg = 0;
80006116:	d602                	sw	zero,44(sp)
    switch (idx) {
80006118:	4732                	lw	a4,12(sp)
8000611a:	478d                	li	a5,3
8000611c:	04f70763          	beq	a4,a5,8000616a <.L2>
80006120:	4732                	lw	a4,12(sp)
80006122:	478d                	li	a5,3
80006124:	04e7e963          	bltu	a5,a4,80006176 <.L9>
80006128:	4732                	lw	a4,12(sp)
8000612a:	4789                	li	a5,2
8000612c:	02f70963          	beq	a4,a5,8000615e <.L4>
80006130:	4732                	lw	a4,12(sp)
80006132:	4789                	li	a5,2
80006134:	04e7e163          	bltu	a5,a4,80006176 <.L9>
80006138:	47b2                	lw	a5,12(sp)
8000613a:	c791                	beqz	a5,80006146 <.L5>
8000613c:	4732                	lw	a4,12(sp)
8000613e:	4785                	li	a5,1
80006140:	00f70963          	beq	a4,a5,80006152 <.L6>
    case 3:
        pmp_cfg = read_csr(CSR_PMPCFG3);
        break;
    default:
        /* Do nothing */
        break;
80006144:	a80d                	j	80006176 <.L9>

80006146 <.L5>:
        pmp_cfg = read_csr(CSR_PMPCFG0);
80006146:	3a0027f3          	csrr	a5,pmpcfg0
8000614a:	ce3e                	sw	a5,28(sp)
8000614c:	47f2                	lw	a5,28(sp)

8000614e <.LBE2>:
8000614e:	d63e                	sw	a5,44(sp)
        break;
80006150:	a025                	j	80006178 <.L7>

80006152 <.L6>:
        pmp_cfg = read_csr(CSR_PMPCFG1);
80006152:	3a1027f3          	csrr	a5,pmpcfg1
80006156:	d03e                	sw	a5,32(sp)
80006158:	5782                	lw	a5,32(sp)

8000615a <.LBE3>:
8000615a:	d63e                	sw	a5,44(sp)
        break;
8000615c:	a831                	j	80006178 <.L7>

8000615e <.L4>:
        pmp_cfg = read_csr(CSR_PMPCFG2);
8000615e:	3a2027f3          	csrr	a5,pmpcfg2
80006162:	d23e                	sw	a5,36(sp)
80006164:	5792                	lw	a5,36(sp)

80006166 <.LBE4>:
80006166:	d63e                	sw	a5,44(sp)
        break;
80006168:	a801                	j	80006178 <.L7>

8000616a <.L2>:
        pmp_cfg = read_csr(CSR_PMPCFG3);
8000616a:	3a3027f3          	csrr	a5,pmpcfg3
8000616e:	d43e                	sw	a5,40(sp)
80006170:	57a2                	lw	a5,40(sp)

80006172 <.LBE5>:
80006172:	d63e                	sw	a5,44(sp)
        break;
80006174:	a011                	j	80006178 <.L7>

80006176 <.L9>:
        break;
80006176:	0001                	nop

80006178 <.L7>:
    }
    return pmp_cfg;
80006178:	57b2                	lw	a5,44(sp)
}
8000617a:	853e                	mv	a0,a5
8000617c:	6145                	addi	sp,sp,48
8000617e:	8082                	ret

Disassembly of section .text.write_pmp_addr:

80006180 <write_pmp_addr>:
        break;
    }
}

void write_pmp_addr(uint32_t value, uint32_t idx)
{
80006180:	1141                	addi	sp,sp,-16
80006182:	c62a                	sw	a0,12(sp)
80006184:	c42e                	sw	a1,8(sp)
    switch (idx) {
80006186:	4722                	lw	a4,8(sp)
80006188:	47bd                	li	a5,15
8000618a:	08e7ea63          	bltu	a5,a4,8000621e <.L38>
8000618e:	47a2                	lw	a5,8(sp)
80006190:	00279713          	slli	a4,a5,0x2
80006194:	abc18793          	addi	a5,gp,-1348 # 80003bf0 <.L21>
80006198:	97ba                	add	a5,a5,a4
8000619a:	439c                	lw	a5,0(a5)
8000619c:	8782                	jr	a5

8000619e <.L36>:
    case 0:
        write_csr(CSR_PMPADDR0, value);
8000619e:	47b2                	lw	a5,12(sp)
800061a0:	3b079073          	csrw	pmpaddr0,a5
        break;
800061a4:	a8b5                	j	80006220 <.L37>

800061a6 <.L35>:
    case 1:
        write_csr(CSR_PMPADDR1, value);
800061a6:	47b2                	lw	a5,12(sp)
800061a8:	3b179073          	csrw	pmpaddr1,a5
        break;
800061ac:	a895                	j	80006220 <.L37>

800061ae <.L34>:
    case 2:
        write_csr(CSR_PMPADDR2, value);
800061ae:	47b2                	lw	a5,12(sp)
800061b0:	3b279073          	csrw	pmpaddr2,a5
        break;
800061b4:	a0b5                	j	80006220 <.L37>

800061b6 <.L33>:
    case 3:
        write_csr(CSR_PMPADDR3, value);
800061b6:	47b2                	lw	a5,12(sp)
800061b8:	3b379073          	csrw	pmpaddr3,a5
        break;
800061bc:	a095                	j	80006220 <.L37>

800061be <.L32>:
    case 4:
        write_csr(CSR_PMPADDR4, value);
800061be:	47b2                	lw	a5,12(sp)
800061c0:	3b479073          	csrw	pmpaddr4,a5
        break;
800061c4:	a8b1                	j	80006220 <.L37>

800061c6 <.L31>:
    case 5:
        write_csr(CSR_PMPADDR5, value);
800061c6:	47b2                	lw	a5,12(sp)
800061c8:	3b579073          	csrw	pmpaddr5,a5
        break;
800061cc:	a891                	j	80006220 <.L37>

800061ce <.L30>:
    case 6:
        write_csr(CSR_PMPADDR6, value);
800061ce:	47b2                	lw	a5,12(sp)
800061d0:	3b679073          	csrw	pmpaddr6,a5
        break;
800061d4:	a0b1                	j	80006220 <.L37>

800061d6 <.L29>:
    case 7:
        write_csr(CSR_PMPADDR7, value);
800061d6:	47b2                	lw	a5,12(sp)
800061d8:	3b779073          	csrw	pmpaddr7,a5
        break;
800061dc:	a091                	j	80006220 <.L37>

800061de <.L28>:
    case 8:
        write_csr(CSR_PMPADDR8, value);
800061de:	47b2                	lw	a5,12(sp)
800061e0:	3b879073          	csrw	pmpaddr8,a5
        break;
800061e4:	a835                	j	80006220 <.L37>

800061e6 <.L27>:
    case 9:
        write_csr(CSR_PMPADDR9, value);
800061e6:	47b2                	lw	a5,12(sp)
800061e8:	3b979073          	csrw	pmpaddr9,a5
        break;
800061ec:	a815                	j	80006220 <.L37>

800061ee <.L26>:
    case 10:
        write_csr(CSR_PMPADDR10, value);
800061ee:	47b2                	lw	a5,12(sp)
800061f0:	3ba79073          	csrw	pmpaddr10,a5
        break;
800061f4:	a035                	j	80006220 <.L37>

800061f6 <.L25>:
    case 11:
        write_csr(CSR_PMPADDR11, value);
800061f6:	47b2                	lw	a5,12(sp)
800061f8:	3bb79073          	csrw	pmpaddr11,a5
        break;
800061fc:	a015                	j	80006220 <.L37>

800061fe <.L24>:
    case 12:
        write_csr(CSR_PMPADDR12, value);
800061fe:	47b2                	lw	a5,12(sp)
80006200:	3bc79073          	csrw	pmpaddr12,a5
        break;
80006204:	a831                	j	80006220 <.L37>

80006206 <.L23>:
    case 13:
        write_csr(CSR_PMPADDR13, value);
80006206:	47b2                	lw	a5,12(sp)
80006208:	3bd79073          	csrw	pmpaddr13,a5
        break;
8000620c:	a811                	j	80006220 <.L37>

8000620e <.L22>:
    case 14:
        write_csr(CSR_PMPADDR14, value);
8000620e:	47b2                	lw	a5,12(sp)
80006210:	3be79073          	csrw	pmpaddr14,a5
        break;
80006214:	a031                	j	80006220 <.L37>

80006216 <.L20>:
    case 15:
        write_csr(CSR_PMPADDR15, value);
80006216:	47b2                	lw	a5,12(sp)
80006218:	3bf79073          	csrw	pmpaddr15,a5
        break;
8000621c:	a011                	j	80006220 <.L37>

8000621e <.L38>:
    default:
        /* Do nothing */
        break;
8000621e:	0001                	nop

80006220 <.L37>:
    }
}
80006220:	0001                	nop
80006222:	0141                	addi	sp,sp,16
80006224:	8082                	ret

Disassembly of section .text.read_pma_cfg:

80006226 <read_pma_cfg>:
    return status_success;
}

#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
uint32_t read_pma_cfg(uint32_t idx)
{
80006226:	7179                	addi	sp,sp,-48
80006228:	c62a                	sw	a0,12(sp)
    uint32_t pma_cfg = 0;
8000622a:	d602                	sw	zero,44(sp)
    switch (idx) {
8000622c:	4732                	lw	a4,12(sp)
8000622e:	478d                	li	a5,3
80006230:	04f70763          	beq	a4,a5,8000627e <.L73>
80006234:	4732                	lw	a4,12(sp)
80006236:	478d                	li	a5,3
80006238:	04e7e963          	bltu	a5,a4,8000628a <.L80>
8000623c:	4732                	lw	a4,12(sp)
8000623e:	4789                	li	a5,2
80006240:	02f70963          	beq	a4,a5,80006272 <.L75>
80006244:	4732                	lw	a4,12(sp)
80006246:	4789                	li	a5,2
80006248:	04e7e163          	bltu	a5,a4,8000628a <.L80>
8000624c:	47b2                	lw	a5,12(sp)
8000624e:	c791                	beqz	a5,8000625a <.L76>
80006250:	4732                	lw	a4,12(sp)
80006252:	4785                	li	a5,1
80006254:	00f70963          	beq	a4,a5,80006266 <.L77>
    case 3:
        pma_cfg = read_csr(CSR_PMACFG3);
        break;
    default:
        /* Do nothing */
        break;
80006258:	a80d                	j	8000628a <.L80>

8000625a <.L76>:
        pma_cfg = read_csr(CSR_PMACFG0);
8000625a:	bc0027f3          	csrr	a5,0xbc0
8000625e:	ce3e                	sw	a5,28(sp)
80006260:	47f2                	lw	a5,28(sp)

80006262 <.LBE24>:
80006262:	d63e                	sw	a5,44(sp)
        break;
80006264:	a025                	j	8000628c <.L78>

80006266 <.L77>:
        pma_cfg = read_csr(CSR_PMACFG1);
80006266:	bc1027f3          	csrr	a5,0xbc1
8000626a:	d03e                	sw	a5,32(sp)
8000626c:	5782                	lw	a5,32(sp)

8000626e <.LBE25>:
8000626e:	d63e                	sw	a5,44(sp)
        break;
80006270:	a831                	j	8000628c <.L78>

80006272 <.L75>:
        pma_cfg = read_csr(CSR_PMACFG2);
80006272:	bc2027f3          	csrr	a5,0xbc2
80006276:	d23e                	sw	a5,36(sp)
80006278:	5792                	lw	a5,36(sp)

8000627a <.LBE26>:
8000627a:	d63e                	sw	a5,44(sp)
        break;
8000627c:	a801                	j	8000628c <.L78>

8000627e <.L73>:
        pma_cfg = read_csr(CSR_PMACFG3);
8000627e:	bc3027f3          	csrr	a5,0xbc3
80006282:	d43e                	sw	a5,40(sp)
80006284:	57a2                	lw	a5,40(sp)

80006286 <.LBE27>:
80006286:	d63e                	sw	a5,44(sp)
        break;
80006288:	a011                	j	8000628c <.L78>

8000628a <.L80>:
        break;
8000628a:	0001                	nop

8000628c <.L78>:
    }
    return pma_cfg;
8000628c:	57b2                	lw	a5,44(sp)
}
8000628e:	853e                	mv	a0,a5
80006290:	6145                	addi	sp,sp,48
80006292:	8082                	ret

Disassembly of section .text.write_pma_addr:

80006294 <write_pma_addr>:
        /* Do nothing */
        break;
    }
}
void write_pma_addr(uint32_t value, uint32_t idx)
{
80006294:	1141                	addi	sp,sp,-16
80006296:	c62a                	sw	a0,12(sp)
80006298:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000629a:	4722                	lw	a4,8(sp)
8000629c:	47bd                	li	a5,15
8000629e:	08e7ea63          	bltu	a5,a4,80006332 <.L109>
800062a2:	47a2                	lw	a5,8(sp)
800062a4:	00279713          	slli	a4,a5,0x2
800062a8:	afc18793          	addi	a5,gp,-1284 # 80003c30 <.L92>
800062ac:	97ba                	add	a5,a5,a4
800062ae:	439c                	lw	a5,0(a5)
800062b0:	8782                	jr	a5

800062b2 <.L107>:
    case 0:
        write_csr(CSR_PMAADDR0, value);
800062b2:	47b2                	lw	a5,12(sp)
800062b4:	bd079073          	csrw	0xbd0,a5
        break;
800062b8:	a8b5                	j	80006334 <.L108>

800062ba <.L106>:
    case 1:
        write_csr(CSR_PMAADDR1, value);
800062ba:	47b2                	lw	a5,12(sp)
800062bc:	bd179073          	csrw	0xbd1,a5
        break;
800062c0:	a895                	j	80006334 <.L108>

800062c2 <.L105>:
    case 2:
        write_csr(CSR_PMAADDR2, value);
800062c2:	47b2                	lw	a5,12(sp)
800062c4:	bd279073          	csrw	0xbd2,a5
        break;
800062c8:	a0b5                	j	80006334 <.L108>

800062ca <.L104>:
    case 3:
        write_csr(CSR_PMAADDR3, value);
800062ca:	47b2                	lw	a5,12(sp)
800062cc:	bd379073          	csrw	0xbd3,a5
        break;
800062d0:	a095                	j	80006334 <.L108>

800062d2 <.L103>:
    case 4:
        write_csr(CSR_PMAADDR4, value);
800062d2:	47b2                	lw	a5,12(sp)
800062d4:	bd479073          	csrw	0xbd4,a5
        break;
800062d8:	a8b1                	j	80006334 <.L108>

800062da <.L102>:
    case 5:
        write_csr(CSR_PMAADDR5, value);
800062da:	47b2                	lw	a5,12(sp)
800062dc:	bd579073          	csrw	0xbd5,a5
        break;
800062e0:	a891                	j	80006334 <.L108>

800062e2 <.L101>:
    case 6:
        write_csr(CSR_PMAADDR6, value);
800062e2:	47b2                	lw	a5,12(sp)
800062e4:	bd679073          	csrw	0xbd6,a5
        break;
800062e8:	a0b1                	j	80006334 <.L108>

800062ea <.L100>:
    case 7:
        write_csr(CSR_PMAADDR7, value);
800062ea:	47b2                	lw	a5,12(sp)
800062ec:	bd779073          	csrw	0xbd7,a5
        break;
800062f0:	a091                	j	80006334 <.L108>

800062f2 <.L99>:
    case 8:
        write_csr(CSR_PMAADDR8, value);
800062f2:	47b2                	lw	a5,12(sp)
800062f4:	bd879073          	csrw	0xbd8,a5
        break;
800062f8:	a835                	j	80006334 <.L108>

800062fa <.L98>:
    case 9:
        write_csr(CSR_PMAADDR9, value);
800062fa:	47b2                	lw	a5,12(sp)
800062fc:	bd979073          	csrw	0xbd9,a5
        break;
80006300:	a815                	j	80006334 <.L108>

80006302 <.L97>:
    case 10:
        write_csr(CSR_PMAADDR10, value);
80006302:	47b2                	lw	a5,12(sp)
80006304:	bda79073          	csrw	0xbda,a5
        break;
80006308:	a035                	j	80006334 <.L108>

8000630a <.L96>:
    case 11:
        write_csr(CSR_PMAADDR11, value);
8000630a:	47b2                	lw	a5,12(sp)
8000630c:	bdb79073          	csrw	0xbdb,a5
        break;
80006310:	a015                	j	80006334 <.L108>

80006312 <.L95>:
    case 12:
        write_csr(CSR_PMAADDR12, value);
80006312:	47b2                	lw	a5,12(sp)
80006314:	bdc79073          	csrw	0xbdc,a5
        break;
80006318:	a831                	j	80006334 <.L108>

8000631a <.L94>:
    case 13:
        write_csr(CSR_PMAADDR13, value);
8000631a:	47b2                	lw	a5,12(sp)
8000631c:	bdd79073          	csrw	0xbdd,a5
        break;
80006320:	a811                	j	80006334 <.L108>

80006322 <.L93>:
    case 14:
        write_csr(CSR_PMAADDR14, value);
80006322:	47b2                	lw	a5,12(sp)
80006324:	bde79073          	csrw	0xbde,a5
        break;
80006328:	a031                	j	80006334 <.L108>

8000632a <.L91>:
    case 15:
        write_csr(CSR_PMAADDR15, value);
8000632a:	47b2                	lw	a5,12(sp)
8000632c:	bdf79073          	csrw	0xbdf,a5
        break;
80006330:	a011                	j	80006334 <.L108>

80006332 <.L109>:
    default:
        /* Do nothing */
        break;
80006332:	0001                	nop

80006334 <.L108>:
    }
}
80006334:	0001                	nop
80006336:	0141                	addi	sp,sp,16
80006338:	8082                	ret

Disassembly of section .text.gpio_config_pin_interrupt:

8000633a <gpio_config_pin_interrupt>:
    }
}


void gpio_config_pin_interrupt(GPIO_Type *ptr, uint32_t gpio_index, uint8_t pin_index, gpio_interrupt_trigger_t trigger)
{
8000633a:	1141                	addi	sp,sp,-16
8000633c:	c62a                	sw	a0,12(sp)
8000633e:	c42e                	sw	a1,8(sp)
80006340:	87b2                	mv	a5,a2
80006342:	8736                	mv	a4,a3
80006344:	00f103a3          	sb	a5,7(sp)
80006348:	87ba                	mv	a5,a4
8000634a:	00f10323          	sb	a5,6(sp)
    switch (trigger) {
8000634e:	00614783          	lbu	a5,6(sp)
80006352:	4711                	li	a4,4
80006354:	0ee78863          	beq	a5,a4,80006444 <.L12>
80006358:	4711                	li	a4,4
8000635a:	12f74063          	blt	a4,a5,8000647a <.L23>
8000635e:	4705                	li	a4,1
80006360:	00f74563          	blt	a4,a5,8000636a <.L14>
80006364:	0007d963          	bgez	a5,80006376 <.L15>
        ptr->TP[gpio_index].SET = 1 << pin_index;
        ptr->PD[gpio_index].SET = 1 << pin_index;
        break;
#endif
    default:
        return;
80006368:	aa09                	j	8000647a <.L23>

8000636a <.L14>:
8000636a:	ffe78713          	addi	a4,a5,-2 # 1fffffe <__NONCACHEABLE_RAM_segment_end__+0xdbfffe>
    switch (trigger) {
8000636e:	4785                	li	a5,1
80006370:	10e7e563          	bltu	a5,a4,8000647a <.L23>
80006374:	a8a9                	j	800063ce <.L22>

80006376 <.L15>:
        ptr->TP[gpio_index].CLEAR = 1 << pin_index;
80006376:	00714783          	lbu	a5,7(sp)
8000637a:	4705                	li	a4,1
8000637c:	00f717b3          	sll	a5,a4,a5
80006380:	86be                	mv	a3,a5
80006382:	4732                	lw	a4,12(sp)
80006384:	47a2                	lw	a5,8(sp)
80006386:	06078793          	addi	a5,a5,96
8000638a:	0792                	slli	a5,a5,0x4
8000638c:	97ba                	add	a5,a5,a4
8000638e:	c794                	sw	a3,8(a5)
        if (trigger == gpio_interrupt_trigger_level_high) {
80006390:	00614783          	lbu	a5,6(sp)
80006394:	ef99                	bnez	a5,800063b2 <.L17>
            ptr->PL[gpio_index].CLEAR = 1 << pin_index;
80006396:	00714783          	lbu	a5,7(sp)
8000639a:	4705                	li	a4,1
8000639c:	00f717b3          	sll	a5,a4,a5
800063a0:	86be                	mv	a3,a5
800063a2:	4732                	lw	a4,12(sp)
800063a4:	47a2                	lw	a5,8(sp)
800063a6:	05078793          	addi	a5,a5,80
800063aa:	0792                	slli	a5,a5,0x4
800063ac:	97ba                	add	a5,a5,a4
800063ae:	c794                	sw	a3,8(a5)
        break;
800063b0:	a0f1                	j	8000647c <.L11>

800063b2 <.L17>:
            ptr->PL[gpio_index].SET = 1 << pin_index;
800063b2:	00714783          	lbu	a5,7(sp)
800063b6:	4705                	li	a4,1
800063b8:	00f717b3          	sll	a5,a4,a5
800063bc:	86be                	mv	a3,a5
800063be:	4732                	lw	a4,12(sp)
800063c0:	47a2                	lw	a5,8(sp)
800063c2:	05078793          	addi	a5,a5,80
800063c6:	0792                	slli	a5,a5,0x4
800063c8:	97ba                	add	a5,a5,a4
800063ca:	c3d4                	sw	a3,4(a5)
        break;
800063cc:	a845                	j	8000647c <.L11>

800063ce <.L22>:
        ptr->PD[gpio_index].CLEAR = 1 << pin_index;
800063ce:	00714783          	lbu	a5,7(sp)
800063d2:	4705                	li	a4,1
800063d4:	00f717b3          	sll	a5,a4,a5
800063d8:	86be                	mv	a3,a5
800063da:	4732                	lw	a4,12(sp)
800063dc:	47a2                	lw	a5,8(sp)
800063de:	08078793          	addi	a5,a5,128
800063e2:	0792                	slli	a5,a5,0x4
800063e4:	97ba                	add	a5,a5,a4
800063e6:	c794                	sw	a3,8(a5)
        ptr->TP[gpio_index].SET = 1 << pin_index;
800063e8:	00714783          	lbu	a5,7(sp)
800063ec:	4705                	li	a4,1
800063ee:	00f717b3          	sll	a5,a4,a5
800063f2:	86be                	mv	a3,a5
800063f4:	4732                	lw	a4,12(sp)
800063f6:	47a2                	lw	a5,8(sp)
800063f8:	06078793          	addi	a5,a5,96
800063fc:	0792                	slli	a5,a5,0x4
800063fe:	97ba                	add	a5,a5,a4
80006400:	c3d4                	sw	a3,4(a5)
        if (trigger == gpio_interrupt_trigger_edge_rising) {
80006402:	00614703          	lbu	a4,6(sp)
80006406:	4789                	li	a5,2
80006408:	02f71063          	bne	a4,a5,80006428 <.L20>
            ptr->PL[gpio_index].CLEAR = 1 << pin_index;
8000640c:	00714783          	lbu	a5,7(sp)
80006410:	4705                	li	a4,1
80006412:	00f717b3          	sll	a5,a4,a5
80006416:	86be                	mv	a3,a5
80006418:	4732                	lw	a4,12(sp)
8000641a:	47a2                	lw	a5,8(sp)
8000641c:	05078793          	addi	a5,a5,80
80006420:	0792                	slli	a5,a5,0x4
80006422:	97ba                	add	a5,a5,a4
80006424:	c794                	sw	a3,8(a5)
        break;
80006426:	a899                	j	8000647c <.L11>

80006428 <.L20>:
            ptr->PL[gpio_index].SET = 1 << pin_index;
80006428:	00714783          	lbu	a5,7(sp)
8000642c:	4705                	li	a4,1
8000642e:	00f717b3          	sll	a5,a4,a5
80006432:	86be                	mv	a3,a5
80006434:	4732                	lw	a4,12(sp)
80006436:	47a2                	lw	a5,8(sp)
80006438:	05078793          	addi	a5,a5,80
8000643c:	0792                	slli	a5,a5,0x4
8000643e:	97ba                	add	a5,a5,a4
80006440:	c3d4                	sw	a3,4(a5)
        break;
80006442:	a82d                	j	8000647c <.L11>

80006444 <.L12>:
        ptr->TP[gpio_index].SET = 1 << pin_index;
80006444:	00714783          	lbu	a5,7(sp)
80006448:	4705                	li	a4,1
8000644a:	00f717b3          	sll	a5,a4,a5
8000644e:	86be                	mv	a3,a5
80006450:	4732                	lw	a4,12(sp)
80006452:	47a2                	lw	a5,8(sp)
80006454:	06078793          	addi	a5,a5,96
80006458:	0792                	slli	a5,a5,0x4
8000645a:	97ba                	add	a5,a5,a4
8000645c:	c3d4                	sw	a3,4(a5)
        ptr->PD[gpio_index].SET = 1 << pin_index;
8000645e:	00714783          	lbu	a5,7(sp)
80006462:	4705                	li	a4,1
80006464:	00f717b3          	sll	a5,a4,a5
80006468:	86be                	mv	a3,a5
8000646a:	4732                	lw	a4,12(sp)
8000646c:	47a2                	lw	a5,8(sp)
8000646e:	08078793          	addi	a5,a5,128
80006472:	0792                	slli	a5,a5,0x4
80006474:	97ba                	add	a5,a5,a4
80006476:	c3d4                	sw	a3,4(a5)
        break;
80006478:	a011                	j	8000647c <.L11>

8000647a <.L23>:
        return;
8000647a:	0001                	nop

8000647c <.L11>:
    }
}
8000647c:	0141                	addi	sp,sp,16
8000647e:	8082                	ret

Disassembly of section .text.gpio_set_pin_output_with_initial:

80006480 <gpio_set_pin_output_with_initial>:

void gpio_set_pin_output_with_initial(GPIO_Type *ptr, uint32_t port, uint8_t pin, uint8_t initial)
{
80006480:	1141                	addi	sp,sp,-16
80006482:	c62a                	sw	a0,12(sp)
80006484:	c42e                	sw	a1,8(sp)
80006486:	87b2                	mv	a5,a2
80006488:	8736                	mv	a4,a3
8000648a:	00f103a3          	sb	a5,7(sp)
8000648e:	87ba                	mv	a5,a4
80006490:	00f10323          	sb	a5,6(sp)
    if (initial & 1) {
80006494:	00614783          	lbu	a5,6(sp)
80006498:	8b85                	andi	a5,a5,1
8000649a:	cf91                	beqz	a5,800064b6 <.L25>
        ptr->DO[port].SET = 1 << pin;
8000649c:	00714783          	lbu	a5,7(sp)
800064a0:	4705                	li	a4,1
800064a2:	00f717b3          	sll	a5,a4,a5
800064a6:	86be                	mv	a3,a5
800064a8:	4732                	lw	a4,12(sp)
800064aa:	47a2                	lw	a5,8(sp)
800064ac:	07c1                	addi	a5,a5,16
800064ae:	0792                	slli	a5,a5,0x4
800064b0:	97ba                	add	a5,a5,a4
800064b2:	c3d4                	sw	a3,4(a5)
800064b4:	a829                	j	800064ce <.L26>

800064b6 <.L25>:
    } else {
        ptr->DO[port].CLEAR = 1 << pin;
800064b6:	00714783          	lbu	a5,7(sp)
800064ba:	4705                	li	a4,1
800064bc:	00f717b3          	sll	a5,a4,a5
800064c0:	86be                	mv	a3,a5
800064c2:	4732                	lw	a4,12(sp)
800064c4:	47a2                	lw	a5,8(sp)
800064c6:	07c1                	addi	a5,a5,16
800064c8:	0792                	slli	a5,a5,0x4
800064ca:	97ba                	add	a5,a5,a4
800064cc:	c794                	sw	a3,8(a5)

800064ce <.L26>:
    }
    ptr->OE[port].SET = 1 << pin;
800064ce:	00714783          	lbu	a5,7(sp)
800064d2:	4705                	li	a4,1
800064d4:	00f717b3          	sll	a5,a4,a5
800064d8:	86be                	mv	a3,a5
800064da:	4732                	lw	a4,12(sp)
800064dc:	47a2                	lw	a5,8(sp)
800064de:	02078793          	addi	a5,a5,32
800064e2:	0792                	slli	a5,a5,0x4
800064e4:	97ba                	add	a5,a5,a4
800064e6:	c3d4                	sw	a3,4(a5)
}
800064e8:	0001                	nop
800064ea:	0141                	addi	sp,sp,16
800064ec:	8082                	ret

Disassembly of section .text.pwmv2_config_async_fault_source:

800064ee <pwmv2_config_async_fault_source>:
        pwmv2_shadow_register_lock(pwm_x);
    }
}

void pwmv2_config_async_fault_source(PWMV2_Type *pwm_x, pwm_channel_t index, pwmv2_async_fault_source_config_t *config)
{
800064ee:	1141                	addi	sp,sp,-16
800064f0:	c62a                	sw	a0,12(sp)
800064f2:	87ae                	mv	a5,a1
800064f4:	c232                	sw	a2,4(sp)
800064f6:	00f105a3          	sb	a5,11(sp)
    pwm_x->PWM[index].CFG0 = (pwm_x->PWM[index].CFG0 & ~(PWMV2_PWM_CFG0_FAULT_SEL_ASYNC_MASK | PWMV2_PWM_CFG0_FAULT_POL_ASYNC_MASK))
800064fa:	00b14783          	lbu	a5,11(sp)
800064fe:	4732                	lw	a4,12(sp)
80006500:	07c1                	addi	a5,a5,16
80006502:	0792                	slli	a5,a5,0x4
80006504:	97ba                	add	a5,a5,a4
80006506:	4398                	lw	a4,0(a5)
80006508:	77fd                	lui	a5,0xfffff
8000650a:	0bf78793          	addi	a5,a5,191 # fffff0bf <__AHB_SRAM_segment_end__+0xfdf70bf>
8000650e:	8f7d                	and	a4,a4,a5
        | PWMV2_PWM_CFG0_FAULT_SEL_ASYNC_SET(config->async_signal_from_pad_index)
80006510:	4792                	lw	a5,4(sp)
80006512:	0007c783          	lbu	a5,0(a5)
80006516:	00879693          	slli	a3,a5,0x8
8000651a:	6785                	lui	a5,0x1
8000651c:	f0078793          	addi	a5,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
80006520:	8ff5                	and	a5,a5,a3
80006522:	00f766b3          	or	a3,a4,a5
        | PWMV2_PWM_CFG0_FAULT_POL_ASYNC_SET(config->fault_async_pad_level);
80006526:	4792                	lw	a5,4(sp)
80006528:	0017c783          	lbu	a5,1(a5)
8000652c:	079a                	slli	a5,a5,0x6
8000652e:	0407f713          	andi	a4,a5,64
    pwm_x->PWM[index].CFG0 = (pwm_x->PWM[index].CFG0 & ~(PWMV2_PWM_CFG0_FAULT_SEL_ASYNC_MASK | PWMV2_PWM_CFG0_FAULT_POL_ASYNC_MASK))
80006532:	00b14783          	lbu	a5,11(sp)
        | PWMV2_PWM_CFG0_FAULT_POL_ASYNC_SET(config->fault_async_pad_level);
80006536:	8f55                	or	a4,a4,a3
    pwm_x->PWM[index].CFG0 = (pwm_x->PWM[index].CFG0 & ~(PWMV2_PWM_CFG0_FAULT_SEL_ASYNC_MASK | PWMV2_PWM_CFG0_FAULT_POL_ASYNC_MASK))
80006538:	46b2                	lw	a3,12(sp)
8000653a:	07c1                	addi	a5,a5,16
8000653c:	0792                	slli	a5,a5,0x4
8000653e:	97b6                	add	a5,a5,a3
80006540:	c398                	sw	a4,0(a5)
}
80006542:	0001                	nop
80006544:	0141                	addi	sp,sp,16
80006546:	8082                	ret

Disassembly of section .text.pllctlv2_pll_is_stable:

80006548 <pllctlv2_pll_is_stable>:
 * @param [in] ptr Base address of the PLLCTLV2 peripheral
 * @param [in] pll Index of the PLL to check (pllctlv2_pll0 through pllctlv2_pll6)
 * @return true if the PLL is stable and locked, false otherwise
 */
static inline bool pllctlv2_pll_is_stable(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
80006548:	1101                	addi	sp,sp,-32
8000654a:	c62a                	sw	a0,12(sp)
8000654c:	87ae                	mv	a5,a1
8000654e:	00f105a3          	sb	a5,11(sp)
    uint32_t status = ptr->PLL[pll].MFI;
80006552:	00b14783          	lbu	a5,11(sp)
80006556:	4732                	lw	a4,12(sp)
80006558:	0785                	addi	a5,a5,1
8000655a:	079e                	slli	a5,a5,0x7
8000655c:	97ba                	add	a5,a5,a4
8000655e:	439c                	lw	a5,0(a5)
80006560:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_MFI_ENABLE_MASK)
80006562:	4772                	lw	a4,28(sp)
80006564:	100007b7          	lui	a5,0x10000
80006568:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_MFI_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_PLL_MFI_RESPONSE_MASK)));
8000656a:	cb89                	beqz	a5,8000657c <.L2>
8000656c:	47f2                	lw	a5,28(sp)
8000656e:	0007c963          	bltz	a5,80006580 <.L3>
80006572:	4772                	lw	a4,28(sp)
80006574:	200007b7          	lui	a5,0x20000
80006578:	8ff9                	and	a5,a5,a4
8000657a:	c399                	beqz	a5,80006580 <.L3>

8000657c <.L2>:
8000657c:	4785                	li	a5,1
8000657e:	a011                	j	80006582 <.L4>

80006580 <.L3>:
80006580:	4781                	li	a5,0

80006582 <.L4>:
80006582:	8b85                	andi	a5,a5,1
80006584:	0ff7f793          	zext.b	a5,a5
}
80006588:	853e                	mv	a0,a5
8000658a:	6105                	addi	sp,sp,32
8000658c:	8082                	ret

Disassembly of section .text.pllctlv2_init_pll_with_freq:

8000658e <pllctlv2_init_pll_with_freq>:
    }
    return status;
}

hpm_stat_t pllctlv2_init_pll_with_freq(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, uint32_t freq_in_hz)
{
8000658e:	7179                	addi	sp,sp,-48
80006590:	d606                	sw	ra,44(sp)
80006592:	c62a                	sw	a0,12(sp)
80006594:	87ae                	mv	a5,a1
80006596:	c232                	sw	a2,4(sp)
80006598:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status;
    if ((ptr == NULL) || (freq_in_hz < PLLCTLV2_PLL_FREQ_MIN) || (freq_in_hz > PLLCTLV2_PLL_FREQ_MAX) ||
8000659c:	47b2                	lw	a5,12(sp)
8000659e:	c395                	beqz	a5,800065c2 <.L19>
800065a0:	4712                	lw	a4,4(sp)
800065a2:	16e367b7          	lui	a5,0x16e36
800065a6:	00f76e63          	bltu	a4,a5,800065c2 <.L19>
800065aa:	4712                	lw	a4,4(sp)
800065ac:	3d8317b7          	lui	a5,0x3d831
800065b0:	20078793          	addi	a5,a5,512 # 3d831200 <__NONCACHEABLE_RAM_segment_end__+0x3c5f1200>
800065b4:	00e7e763          	bltu	a5,a4,800065c2 <.L19>
800065b8:	00b14703          	lbu	a4,11(sp)
800065bc:	4789                	li	a5,2
800065be:	00e7f563          	bgeu	a5,a4,800065c8 <.L20>

800065c2 <.L19>:
        (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
        status = status_invalid_argument;
800065c2:	4789                	li	a5,2
800065c4:	ce3e                	sw	a5,28(sp)
800065c6:	a8bd                	j	80006644 <.L21>

800065c8 <.L20>:
    } else {
        uint32_t mfn = freq_in_hz % PLLCTLV2_PLL_XTAL_FREQ;
800065c8:	4792                	lw	a5,4(sp)
800065ca:	165ea737          	lui	a4,0x165ea
800065ce:	f8170713          	addi	a4,a4,-127 # 165e9f81 <__NONCACHEABLE_RAM_segment_end__+0x153a9f81>
800065d2:	02e7b733          	mulhu	a4,a5,a4
800065d6:	01575693          	srli	a3,a4,0x15
800065da:	016e3737          	lui	a4,0x16e3
800065de:	60070713          	addi	a4,a4,1536 # 16e3600 <__NONCACHEABLE_RAM_segment_end__+0x4a3600>
800065e2:	02e68733          	mul	a4,a3,a4
800065e6:	8f99                	sub	a5,a5,a4
800065e8:	cc3e                	sw	a5,24(sp)
        uint32_t mfi = freq_in_hz / PLLCTLV2_PLL_XTAL_FREQ;
800065ea:	4712                	lw	a4,4(sp)
800065ec:	165ea7b7          	lui	a5,0x165ea
800065f0:	f8178793          	addi	a5,a5,-127 # 165e9f81 <__NONCACHEABLE_RAM_segment_end__+0x153a9f81>
800065f4:	02f737b3          	mulhu	a5,a4,a5
800065f8:	83d5                	srli	a5,a5,0x15
800065fa:	ca3e                	sw	a5,20(sp)

        /*
         * NOTE: Default MFD value is 240M
         */
        ptr->PLL[pll].MFN = mfn * PLLCTLV2_PLL_MFN_FACTOR;
800065fc:	00b14683          	lbu	a3,11(sp)
80006600:	4762                	lw	a4,24(sp)
80006602:	87ba                	mv	a5,a4
80006604:	078a                	slli	a5,a5,0x2
80006606:	97ba                	add	a5,a5,a4
80006608:	0786                	slli	a5,a5,0x1
8000660a:	863e                	mv	a2,a5
8000660c:	4732                	lw	a4,12(sp)
8000660e:	00168793          	addi	a5,a3,1 # f4000001 <__AHB_SRAM_segment_end__+0x3df8001>
80006612:	079e                	slli	a5,a5,0x7
80006614:	97ba                	add	a5,a5,a4
80006616:	c3d0                	sw	a2,4(a5)
        ptr->PLL[pll].MFI = mfi;
80006618:	00b14783          	lbu	a5,11(sp)
8000661c:	4732                	lw	a4,12(sp)
8000661e:	0785                	addi	a5,a5,1
80006620:	079e                	slli	a5,a5,0x7
80006622:	97ba                	add	a5,a5,a4
80006624:	4752                	lw	a4,20(sp)
80006626:	c398                	sw	a4,0(a5)


        while (!pllctlv2_pll_is_stable(ptr, pll)) {
80006628:	a011                	j	8000662c <.L22>

8000662a <.L23>:
            NOP();
8000662a:	0001                	nop

8000662c <.L22>:
        while (!pllctlv2_pll_is_stable(ptr, pll)) {
8000662c:	00b14783          	lbu	a5,11(sp)
80006630:	85be                	mv	a1,a5
80006632:	4532                	lw	a0,12(sp)
80006634:	3f11                	jal	80006548 <pllctlv2_pll_is_stable>
80006636:	87aa                	mv	a5,a0
80006638:	0017c793          	xori	a5,a5,1
8000663c:	0ff7f793          	zext.b	a5,a5
80006640:	f7ed                	bnez	a5,8000662a <.L23>
        }

        status = status_success;
80006642:	ce02                	sw	zero,28(sp)

80006644 <.L21>:
    }
    return status;
80006644:	47f2                	lw	a5,28(sp)
}
80006646:	853e                	mv	a0,a5
80006648:	50b2                	lw	ra,44(sp)
8000664a:	6145                	addi	sp,sp,48
8000664c:	8082                	ret

Disassembly of section .text.adc16_get_default_config:

8000664e <adc16_get_default_config>:
#ifndef ADC16_RETRY_TO_GET_RESULT_COUNT
#define ADC16_RETRY_TO_GET_RESULT_COUNT (100U)
#endif

void adc16_get_default_config(adc16_config_t *config)
{
8000664e:	1141                	addi	sp,sp,-16
80006650:	c62a                	sw	a0,12(sp)
    config->res                = adc16_res_16_bits;
80006652:	47b2                	lw	a5,12(sp)
80006654:	4755                	li	a4,21
80006656:	00e78023          	sb	a4,0(a5)
    config->conv_mode          = adc16_conv_mode_oneshot;
8000665a:	47b2                	lw	a5,12(sp)
8000665c:	000780a3          	sb	zero,1(a5)
    config->adc_clk_div        = adc16_clock_divider_1;
80006660:	47b2                	lw	a5,12(sp)
80006662:	4705                	li	a4,1
80006664:	c3d8                	sw	a4,4(a5)
    config->wait_dis           = true;
80006666:	47b2                	lw	a5,12(sp)
80006668:	4705                	li	a4,1
8000666a:	00e784a3          	sb	a4,9(a5)
    config->sel_sync_ahb       = true;
8000666e:	47b2                	lw	a5,12(sp)
80006670:	4705                	li	a4,1
80006672:	00e78523          	sb	a4,10(a5)
    config->port3_realtime     = false;
80006676:	47b2                	lw	a5,12(sp)
80006678:	00078423          	sb	zero,8(a5)
    config->adc_ahb_en         = false;
8000667c:	47b2                	lw	a5,12(sp)
8000667e:	000785a3          	sb	zero,11(a5)
}
80006682:	0001                	nop
80006684:	0141                	addi	sp,sp,16
80006686:	8082                	ret

Disassembly of section .text.pcfg_dcdc_switch_to_dcm_mode:

80006688 <pcfg_dcdc_switch_to_dcm_mode>:
    ptr->DCDC_LPMODE = (ptr->DCDC_LPMODE & ~PCFG_DCDC_LPMODE_STBY_VOLT_MASK) | PCFG_DCDC_LPMODE_STBY_VOLT_SET(mv);
    return stat;
}

void pcfg_dcdc_switch_to_dcm_mode(PCFG_Type *ptr)
{
80006688:	7139                	addi	sp,sp,-64
8000668a:	c62a                	sw	a0,12(sp)
    const uint8_t pcfc_dcdc_min_duty_cycle[] = {
8000668c:	b3c18793          	addi	a5,gp,-1220 # 80003c70 <.LC0>
80006690:	0007a883          	lw	a7,0(a5)
80006694:	0047a803          	lw	a6,4(a5)
80006698:	4788                	lw	a0,8(a5)
8000669a:	47cc                	lw	a1,12(a5)
8000669c:	4b90                	lw	a2,16(a5)
8000669e:	4bd4                	lw	a3,20(a5)
800066a0:	4f98                	lw	a4,24(a5)
800066a2:	4fdc                	lw	a5,28(a5)
800066a4:	ce46                	sw	a7,28(sp)
800066a6:	d042                	sw	a6,32(sp)
800066a8:	d22a                	sw	a0,36(sp)
800066aa:	d42e                	sw	a1,40(sp)
800066ac:	d632                	sw	a2,44(sp)
800066ae:	d836                	sw	a3,48(sp)
800066b0:	da3a                	sw	a4,52(sp)
800066b2:	dc3e                	sw	a5,56(sp)
        0x76, 0x78, 0x78, 0x78, 0x78, 0x7A, 0x7A, 0x7A,
        0x7A, 0x7C, 0x7C, 0x7C, 0x7E, 0x7E, 0x7E, 0x7E
    };
    uint16_t voltage;

    ptr->DCDC_MODE |= 0x77000u;
800066b4:	47b2                	lw	a5,12(sp)
800066b6:	4b98                	lw	a4,16(a5)
800066b8:	000777b7          	lui	a5,0x77
800066bc:	8f5d                	or	a4,a4,a5
800066be:	47b2                	lw	a5,12(sp)
800066c0:	cb98                	sw	a4,16(a5)
    ptr->DCDC_ADVMODE = (ptr->DCDC_ADVMODE & ~0x73F0067u) | 0x4120067u;
800066c2:	47b2                	lw	a5,12(sp)
800066c4:	5398                	lw	a4,32(a5)
800066c6:	f8c107b7          	lui	a5,0xf8c10
800066ca:	f9878793          	addi	a5,a5,-104 # f8c0ff98 <__AHB_SRAM_segment_end__+0x8a07f98>
800066ce:	8f7d                	and	a4,a4,a5
800066d0:	041207b7          	lui	a5,0x4120
800066d4:	06778793          	addi	a5,a5,103 # 4120067 <__NONCACHEABLE_RAM_segment_end__+0x2ee0067>
800066d8:	8f5d                	or	a4,a4,a5
800066da:	47b2                	lw	a5,12(sp)
800066dc:	d398                	sw	a4,32(a5)
    ptr->DCDC_PROT &= ~PCFG_DCDC_PROT_SHORT_CURRENT_MASK;
800066de:	47b2                	lw	a5,12(sp)
800066e0:	4f9c                	lw	a5,24(a5)
800066e2:	fef7f713          	andi	a4,a5,-17
800066e6:	47b2                	lw	a5,12(sp)
800066e8:	cf98                	sw	a4,24(a5)
    ptr->DCDC_PROT |= PCFG_DCDC_PROT_DISABLE_SHORT_MASK;
800066ea:	47b2                	lw	a5,12(sp)
800066ec:	4f9c                	lw	a5,24(a5)
800066ee:	0807e713          	ori	a4,a5,128
800066f2:	47b2                	lw	a5,12(sp)
800066f4:	cf98                	sw	a4,24(a5)
    ptr->DCDC_MISC = 0x100000u;
800066f6:	47b2                	lw	a5,12(sp)
800066f8:	00100737          	lui	a4,0x100
800066fc:	d798                	sw	a4,40(a5)
    voltage = PCFG_DCDC_MODE_VOLT_GET(ptr->DCDC_MODE);
800066fe:	47b2                	lw	a5,12(sp)
80006700:	4b9c                	lw	a5,16(a5)
80006702:	0807c733          	zext.h	a4,a5
80006706:	6785                	lui	a5,0x1
80006708:	17fd                	addi	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
8000670a:	8ff9                	and	a5,a5,a4
8000670c:	02f11f23          	sh	a5,62(sp)
    voltage = (voltage - 600) / 25;
80006710:	03e15783          	lhu	a5,62(sp)
80006714:	da878793          	addi	a5,a5,-600
80006718:	51eb8737          	lui	a4,0x51eb8
8000671c:	51f70713          	addi	a4,a4,1311 # 51eb851f <__NONCACHEABLE_RAM_segment_end__+0x50c7851f>
80006720:	02e79733          	mulh	a4,a5,a4
80006724:	870d                	srai	a4,a4,0x3
80006726:	87fd                	srai	a5,a5,0x1f
80006728:	40f707b3          	sub	a5,a4,a5
8000672c:	02f11f23          	sh	a5,62(sp)
    ptr->DCDC_ADVPARAM = (ptr->DCDC_ADVPARAM & ~PCFG_DCDC_ADVPARAM_MIN_DUT_MASK) | PCFG_DCDC_ADVPARAM_MIN_DUT_SET(pcfc_dcdc_min_duty_cycle[voltage]);
80006730:	47b2                	lw	a5,12(sp)
80006732:	53d8                	lw	a4,36(a5)
80006734:	77e1                	lui	a5,0xffff8
80006736:	0ff78793          	addi	a5,a5,255 # ffff80ff <__AHB_SRAM_segment_end__+0xfdf00ff>
8000673a:	8f7d                	and	a4,a4,a5
8000673c:	03e15783          	lhu	a5,62(sp)
80006740:	04078793          	addi	a5,a5,64
80006744:	978a                	add	a5,a5,sp
80006746:	fdc7c783          	lbu	a5,-36(a5)
8000674a:	00879693          	slli	a3,a5,0x8
8000674e:	67a1                	lui	a5,0x8
80006750:	f0078793          	addi	a5,a5,-256 # 7f00 <__HEAPSIZE__+0x3f00>
80006754:	8ff5                	and	a5,a5,a3
80006756:	8f5d                	or	a4,a4,a5
80006758:	47b2                	lw	a5,12(sp)
8000675a:	d3d8                	sw	a4,36(a5)
}
8000675c:	0001                	nop
8000675e:	6121                	addi	sp,sp,64
80006760:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

80006762 <__SEGGER_RTL_xtoa>:
80006762:	882e                	mv	a6,a1
80006764:	ca91                	beqz	a3,80006778 <__SEGGER_RTL_xtoa+0x16>
80006766:	00180693          	addi	a3,a6,1
8000676a:	02d00593          	li	a1,45
8000676e:	00b80023          	sb	a1,0(a6)
80006772:	40a00533          	neg	a0,a0
80006776:	a011                	j	8000677a <__SEGGER_RTL_xtoa+0x18>
80006778:	86c2                	mv	a3,a6
8000677a:	ffe68713          	addi	a4,a3,-2
8000677e:	48a5                	li	a7,9
80006780:	85aa                	mv	a1,a0
80006782:	02c55533          	divu	a0,a0,a2
80006786:	02c507b3          	mul	a5,a0,a2
8000678a:	40f587b3          	sub	a5,a1,a5
8000678e:	00f8e563          	bltu	a7,a5,80006798 <__SEGGER_RTL_xtoa+0x36>
80006792:	03078793          	addi	a5,a5,48
80006796:	a019                	j	8000679c <__SEGGER_RTL_xtoa+0x3a>
80006798:	05778793          	addi	a5,a5,87
8000679c:	00f70123          	sb	a5,2(a4)
800067a0:	0705                	addi	a4,a4,1
800067a2:	fcc5ffe3          	bgeu	a1,a2,80006780 <__SEGGER_RTL_xtoa+0x1e>
800067a6:	00070123          	sb	zero,2(a4)
800067aa:	0006c503          	lbu	a0,0(a3)
800067ae:	85ba                	mv	a1,a4
800067b0:	00174603          	lbu	a2,1(a4)
800067b4:	00a700a3          	sb	a0,1(a4)
800067b8:	00168513          	addi	a0,a3,1
800067bc:	00c68023          	sb	a2,0(a3)
800067c0:	177d                	addi	a4,a4,-1
800067c2:	86aa                	mv	a3,a0
800067c4:	feb563e3          	bltu	a0,a1,800067aa <__SEGGER_RTL_xtoa+0x48>
800067c8:	8542                	mv	a0,a6
800067ca:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

800067cc <__SEGGER_RTL_X_assert>:
800067cc:	1101                	addi	sp,sp,-32
800067ce:	ce06                	sw	ra,28(sp)
800067d0:	cc22                	sw	s0,24(sp)
800067d2:	ca26                	sw	s1,20(sp)
800067d4:	86b2                	mv	a3,a2
800067d6:	842e                	mv	s0,a1
800067d8:	84aa                	mv	s1,a0
800067da:	004c                	addi	a1,sp,4
800067dc:	4629                	li	a2,10
800067de:	8536                	mv	a0,a3
800067e0:	718030ef          	jal	80009ef8 <itoa>
800067e4:	8522                	mv	a0,s0
800067e6:	7a0030ef          	jal	80009f86 <__SEGGER_RTL_puts_no_nl>
800067ea:	8000b537          	lui	a0,0x8000b
800067ee:	01750513          	addi	a0,a0,23 # 8000b017 <.L.str>
800067f2:	794030ef          	jal	80009f86 <__SEGGER_RTL_puts_no_nl>
800067f6:	0048                	addi	a0,sp,4
800067f8:	78e030ef          	jal	80009f86 <__SEGGER_RTL_puts_no_nl>
800067fc:	22318513          	addi	a0,gp,547 # 80004357 <.L.str.1>
80006800:	786030ef          	jal	80009f86 <__SEGGER_RTL_puts_no_nl>
80006804:	8526                	mv	a0,s1
80006806:	780030ef          	jal	80009f86 <__SEGGER_RTL_puts_no_nl>
8000680a:	8000b537          	lui	a0,0x8000b
8000680e:	01950513          	addi	a0,a0,25 # 8000b019 <.L.str.2>
80006812:	774030ef          	jal	80009f86 <__SEGGER_RTL_puts_no_nl>
80006816:	70e030ef          	jal	80009f24 <abort>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

8000681a <__SEGGER_RTL_SIGNAL_SIG_ERR>:
8000681a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

8000681c <__SEGGER_RTL_SIGNAL_SIG_IGN>:
8000681c:	8082                	ret

Disassembly of section .text.libc.__subsf3:

8000681e <__subsf3>:
8000681e:	80000637          	lui	a2,0x80000
80006822:	8db1                	xor	a1,a1,a2
80006824:	a009                	j	80006826 <__addsf3>

Disassembly of section .text.libc.__addsf3:

80006826 <__addsf3>:
80006826:	80000637          	lui	a2,0x80000
8000682a:	00b546b3          	xor	a3,a0,a1
8000682e:	0806ca63          	bltz	a3,800068c2 <.L__addsf3_subtract>
80006832:	00b57563          	bgeu	a0,a1,8000683c <.L__addsf3_add_already_ordered>
80006836:	86aa                	mv	a3,a0
80006838:	852e                	mv	a0,a1
8000683a:	85b6                	mv	a1,a3

8000683c <.L__addsf3_add_already_ordered>:
8000683c:	00151713          	slli	a4,a0,0x1
80006840:	8361                	srli	a4,a4,0x18
80006842:	00159693          	slli	a3,a1,0x1
80006846:	82e1                	srli	a3,a3,0x18
80006848:	0ff00293          	li	t0,255
8000684c:	06570563          	beq	a4,t0,800068b6 <.L__addsf3_add_inf_or_nan>
80006850:	c325                	beqz	a4,800068b0 <.L__addsf3_zero>
80006852:	ceb1                	beqz	a3,800068ae <.L__addsf3_add_done>
80006854:	40d706b3          	sub	a3,a4,a3
80006858:	42e1                	li	t0,24
8000685a:	04d2ca63          	blt	t0,a3,800068ae <.L__addsf3_add_done>
8000685e:	05a2                	slli	a1,a1,0x8
80006860:	8dd1                	or	a1,a1,a2
80006862:	01755713          	srli	a4,a0,0x17
80006866:	0522                	slli	a0,a0,0x8
80006868:	8d51                	or	a0,a0,a2
8000686a:	47e5                	li	a5,25
8000686c:	8f95                	sub	a5,a5,a3
8000686e:	00f59633          	sll	a2,a1,a5
80006872:	821d                	srli	a2,a2,0x7
80006874:	00d5d5b3          	srl	a1,a1,a3
80006878:	00b507b3          	add	a5,a0,a1
8000687c:	00a7f463          	bgeu	a5,a0,80006884 <.L__addsf3_add_no_normalization>
80006880:	8385                	srli	a5,a5,0x1
80006882:	0709                	addi	a4,a4,2

80006884 <.L__addsf3_add_no_normalization>:
80006884:	177d                	addi	a4,a4,-1
80006886:	0ff77593          	zext.b	a1,a4
8000688a:	f0158593          	addi	a1,a1,-255 # 3fffff01 <__NONCACHEABLE_RAM_segment_end__+0x3edbff01>
8000688e:	cd91                	beqz	a1,800068aa <.L__addsf3_inf>
80006890:	075e                	slli	a4,a4,0x17
80006892:	0087d513          	srli	a0,a5,0x8
80006896:	07e2                	slli	a5,a5,0x18
80006898:	8fd1                	or	a5,a5,a2
8000689a:	0007d663          	bgez	a5,800068a6 <.L__addsf3_no_tie>
8000689e:	0786                	slli	a5,a5,0x1
800068a0:	0505                	addi	a0,a0,1
800068a2:	e391                	bnez	a5,800068a6 <.L__addsf3_no_tie>
800068a4:	9979                	andi	a0,a0,-2

800068a6 <.L__addsf3_no_tie>:
800068a6:	953a                	add	a0,a0,a4
800068a8:	8082                	ret

800068aa <.L__addsf3_inf>:
800068aa:	01771513          	slli	a0,a4,0x17

800068ae <.L__addsf3_add_done>:
800068ae:	8082                	ret

800068b0 <.L__addsf3_zero>:
800068b0:	817d                	srli	a0,a0,0x1f
800068b2:	057e                	slli	a0,a0,0x1f
800068b4:	8082                	ret

800068b6 <.L__addsf3_add_inf_or_nan>:
800068b6:	00951613          	slli	a2,a0,0x9
800068ba:	da75                	beqz	a2,800068ae <.L__addsf3_add_done>

800068bc <.L__addsf3_return_nan>:
800068bc:	7fc00537          	lui	a0,0x7fc00
800068c0:	8082                	ret

800068c2 <.L__addsf3_subtract>:
800068c2:	8db1                	xor	a1,a1,a2
800068c4:	40b506b3          	sub	a3,a0,a1
800068c8:	00b57563          	bgeu	a0,a1,800068d2 <.L__addsf3_sub_already_ordered>
800068cc:	8eb1                	xor	a3,a3,a2
800068ce:	8d15                	sub	a0,a0,a3
800068d0:	95b6                	add	a1,a1,a3

800068d2 <.L__addsf3_sub_already_ordered>:
800068d2:	00159693          	slli	a3,a1,0x1
800068d6:	82e1                	srli	a3,a3,0x18
800068d8:	00151713          	slli	a4,a0,0x1
800068dc:	8361                	srli	a4,a4,0x18
800068de:	05a2                	slli	a1,a1,0x8
800068e0:	8dd1                	or	a1,a1,a2
800068e2:	0ff00293          	li	t0,255
800068e6:	0c570c63          	beq	a4,t0,800069be <.L__addsf3_sub_inf_or_nan>
800068ea:	c2f5                	beqz	a3,800069ce <.L__addsf3_sub_zero>
800068ec:	40d706b3          	sub	a3,a4,a3
800068f0:	c695                	beqz	a3,8000691c <.L__addsf3_exponents_equal>
800068f2:	4285                	li	t0,1
800068f4:	08569063          	bne	a3,t0,80006974 <.L__addsf3_exponents_differ_by_more_than_1>
800068f8:	01755693          	srli	a3,a0,0x17
800068fc:	0526                	slli	a0,a0,0x9
800068fe:	00b532b3          	sltu	t0,a0,a1
80006902:	8d0d                	sub	a0,a0,a1
80006904:	02029263          	bnez	t0,80006928 <.L__addsf3_normalization_steps>
80006908:	06de                	slli	a3,a3,0x17
8000690a:	01751593          	slli	a1,a0,0x17
8000690e:	8125                	srli	a0,a0,0x9
80006910:	0005d463          	bgez	a1,80006918 <.L__addsf3_sub_no_tie_single>
80006914:	0505                	addi	a0,a0,1 # 7fc00001 <__NONCACHEABLE_RAM_segment_end__+0x7e9c0001>
80006916:	9979                	andi	a0,a0,-2

80006918 <.L__addsf3_sub_no_tie_single>:
80006918:	9536                	add	a0,a0,a3

8000691a <.L__addsf3_sub_done>:
8000691a:	8082                	ret

8000691c <.L__addsf3_exponents_equal>:
8000691c:	01755693          	srli	a3,a0,0x17
80006920:	0526                	slli	a0,a0,0x9
80006922:	0586                	slli	a1,a1,0x1
80006924:	8d0d                	sub	a0,a0,a1
80006926:	d975                	beqz	a0,8000691a <.L__addsf3_sub_done>

80006928 <.L__addsf3_normalization_steps>:
80006928:	4581                	li	a1,0
8000692a:	01055793          	srli	a5,a0,0x10
8000692e:	e399                	bnez	a5,80006934 <.Ltmp0>
80006930:	0542                	slli	a0,a0,0x10
80006932:	05c1                	addi	a1,a1,16

80006934 <.Ltmp0>:
80006934:	01855793          	srli	a5,a0,0x18
80006938:	e399                	bnez	a5,8000693e <.Ltmp1>
8000693a:	0522                	slli	a0,a0,0x8
8000693c:	05a1                	addi	a1,a1,8

8000693e <.Ltmp1>:
8000693e:	01c55793          	srli	a5,a0,0x1c
80006942:	e399                	bnez	a5,80006948 <.Ltmp2>
80006944:	0512                	slli	a0,a0,0x4
80006946:	0591                	addi	a1,a1,4

80006948 <.Ltmp2>:
80006948:	01e55793          	srli	a5,a0,0x1e
8000694c:	e399                	bnez	a5,80006952 <.Ltmp3>
8000694e:	050a                	slli	a0,a0,0x2
80006950:	0589                	addi	a1,a1,2

80006952 <.Ltmp3>:
80006952:	00054463          	bltz	a0,8000695a <.Ltmp4>
80006956:	0506                	slli	a0,a0,0x1
80006958:	0585                	addi	a1,a1,1

8000695a <.Ltmp4>:
8000695a:	0585                	addi	a1,a1,1
8000695c:	0506                	slli	a0,a0,0x1
8000695e:	00e5f763          	bgeu	a1,a4,8000696c <.L__addsf3_underflow>
80006962:	8e8d                	sub	a3,a3,a1
80006964:	06de                	slli	a3,a3,0x17
80006966:	8125                	srli	a0,a0,0x9
80006968:	9536                	add	a0,a0,a3
8000696a:	8082                	ret

8000696c <.L__addsf3_underflow>:
8000696c:	0086d513          	srli	a0,a3,0x8
80006970:	057e                	slli	a0,a0,0x1f
80006972:	8082                	ret

80006974 <.L__addsf3_exponents_differ_by_more_than_1>:
80006974:	42e5                	li	t0,25
80006976:	fad2e2e3          	bltu	t0,a3,8000691a <.L__addsf3_sub_done>
8000697a:	0685                	addi	a3,a3,1
8000697c:	40d00733          	neg	a4,a3
80006980:	00e59733          	sll	a4,a1,a4
80006984:	00d5d5b3          	srl	a1,a1,a3
80006988:	00e03733          	snez	a4,a4
8000698c:	95ae                	add	a1,a1,a1
8000698e:	95ba                	add	a1,a1,a4
80006990:	01755693          	srli	a3,a0,0x17
80006994:	0522                	slli	a0,a0,0x8
80006996:	8d51                	or	a0,a0,a2
80006998:	40b50733          	sub	a4,a0,a1
8000699c:	00074463          	bltz	a4,800069a4 <.L__addsf3_sub_already_normalized>
800069a0:	070a                	slli	a4,a4,0x2
800069a2:	8305                	srli	a4,a4,0x1

800069a4 <.L__addsf3_sub_already_normalized>:
800069a4:	16fd                	addi	a3,a3,-1
800069a6:	06de                	slli	a3,a3,0x17
800069a8:	00875513          	srli	a0,a4,0x8
800069ac:	0762                	slli	a4,a4,0x18
800069ae:	00075663          	bgez	a4,800069ba <.L__addsf3_sub_no_tie>
800069b2:	0706                	slli	a4,a4,0x1
800069b4:	0505                	addi	a0,a0,1
800069b6:	e311                	bnez	a4,800069ba <.L__addsf3_sub_no_tie>
800069b8:	9979                	andi	a0,a0,-2

800069ba <.L__addsf3_sub_no_tie>:
800069ba:	9536                	add	a0,a0,a3
800069bc:	8082                	ret

800069be <.L__addsf3_sub_inf_or_nan>:
800069be:	0ff00293          	li	t0,255
800069c2:	ee568de3          	beq	a3,t0,800068bc <.L__addsf3_return_nan>
800069c6:	00951593          	slli	a1,a0,0x9
800069ca:	d9a1                	beqz	a1,8000691a <.L__addsf3_sub_done>
800069cc:	bdc5                	j	800068bc <.L__addsf3_return_nan>

800069ce <.L__addsf3_sub_zero>:
800069ce:	f731                	bnez	a4,8000691a <.L__addsf3_sub_done>
800069d0:	4501                	li	a0,0
800069d2:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

800069d4 <__ltsf2>:
800069d4:	ff000637          	lui	a2,0xff000
800069d8:	00151693          	slli	a3,a0,0x1
800069dc:	02d66763          	bltu	a2,a3,80006a0a <.L__ltsf2_zero>
800069e0:	00159693          	slli	a3,a1,0x1
800069e4:	02d66363          	bltu	a2,a3,80006a0a <.L__ltsf2_zero>
800069e8:	00b56633          	or	a2,a0,a1
800069ec:	00161693          	slli	a3,a2,0x1
800069f0:	ce89                	beqz	a3,80006a0a <.L__ltsf2_zero>
800069f2:	00064763          	bltz	a2,80006a00 <.L__ltsf2_negative>
800069f6:	00b53533          	sltu	a0,a0,a1
800069fa:	40a00533          	neg	a0,a0
800069fe:	8082                	ret

80006a00 <.L__ltsf2_negative>:
80006a00:	00a5b533          	sltu	a0,a1,a0
80006a04:	40a00533          	neg	a0,a0
80006a08:	8082                	ret

80006a0a <.L__ltsf2_zero>:
80006a0a:	4501                	li	a0,0
80006a0c:	8082                	ret

Disassembly of section .text.libc.__lesf2:

80006a0e <__lesf2>:
80006a0e:	ff000637          	lui	a2,0xff000
80006a12:	00151693          	slli	a3,a0,0x1
80006a16:	02d66363          	bltu	a2,a3,80006a3c <.L__lesf2_nan>
80006a1a:	00159693          	slli	a3,a1,0x1
80006a1e:	00d66f63          	bltu	a2,a3,80006a3c <.L__lesf2_nan>
80006a22:	00b56633          	or	a2,a0,a1
80006a26:	00161693          	slli	a3,a2,0x1
80006a2a:	ca99                	beqz	a3,80006a40 <.L__lesf2_zero>
80006a2c:	00064563          	bltz	a2,80006a36 <.L__lesf2_negative>
80006a30:	00a5b533          	sltu	a0,a1,a0
80006a34:	8082                	ret

80006a36 <.L__lesf2_negative>:
80006a36:	00b53533          	sltu	a0,a0,a1
80006a3a:	8082                	ret

80006a3c <.L__lesf2_nan>:
80006a3c:	4505                	li	a0,1
80006a3e:	8082                	ret

80006a40 <.L__lesf2_zero>:
80006a40:	4501                	li	a0,0
80006a42:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

80006a44 <__gtsf2>:
80006a44:	ff000637          	lui	a2,0xff000
80006a48:	00151693          	slli	a3,a0,0x1
80006a4c:	02d66363          	bltu	a2,a3,80006a72 <.L__gtsf2_zero>
80006a50:	00159693          	slli	a3,a1,0x1
80006a54:	00d66f63          	bltu	a2,a3,80006a72 <.L__gtsf2_zero>
80006a58:	00b56633          	or	a2,a0,a1
80006a5c:	00161693          	slli	a3,a2,0x1
80006a60:	ca89                	beqz	a3,80006a72 <.L__gtsf2_zero>
80006a62:	00064563          	bltz	a2,80006a6c <.L__gtsf2_negative>
80006a66:	00a5b533          	sltu	a0,a1,a0
80006a6a:	8082                	ret

80006a6c <.L__gtsf2_negative>:
80006a6c:	00b53533          	sltu	a0,a0,a1
80006a70:	8082                	ret

80006a72 <.L__gtsf2_zero>:
80006a72:	4501                	li	a0,0
80006a74:	8082                	ret

Disassembly of section .text.libc.__gesf2:

80006a76 <__gesf2>:
80006a76:	ff000637          	lui	a2,0xff000
80006a7a:	00151693          	slli	a3,a0,0x1
80006a7e:	02d66763          	bltu	a2,a3,80006aac <.L__gesf2_nan>
80006a82:	00159693          	slli	a3,a1,0x1
80006a86:	02d66363          	bltu	a2,a3,80006aac <.L__gesf2_nan>
80006a8a:	00b56633          	or	a2,a0,a1
80006a8e:	00161693          	slli	a3,a2,0x1
80006a92:	ce99                	beqz	a3,80006ab0 <.L__gesf2_zero>
80006a94:	00064763          	bltz	a2,80006aa2 <.L__gesf2_negative>
80006a98:	00b53533          	sltu	a0,a0,a1
80006a9c:	40a00533          	neg	a0,a0
80006aa0:	8082                	ret

80006aa2 <.L__gesf2_negative>:
80006aa2:	00a5b533          	sltu	a0,a1,a0
80006aa6:	40a00533          	neg	a0,a0
80006aaa:	8082                	ret

80006aac <.L__gesf2_nan>:
80006aac:	557d                	li	a0,-1
80006aae:	8082                	ret

80006ab0 <.L__gesf2_zero>:
80006ab0:	4501                	li	a0,0
80006ab2:	8082                	ret

Disassembly of section .text.libc.__fixsfsi:

80006ab4 <__fixsfsi>:
80006ab4:	41f55793          	srai	a5,a0,0x1f
80006ab8:	00151613          	slli	a2,a0,0x1
80006abc:	01865593          	srli	a1,a2,0x18
80006ac0:	f8158593          	addi	a1,a1,-127
80006ac4:	0005cf63          	bltz	a1,80006ae2 <.L__fixsfsi_zero_result>
80006ac8:	800006b7          	lui	a3,0x80000
80006acc:	477d                	li	a4,31
80006ace:	8f0d                	sub	a4,a4,a1
80006ad0:	00e05b63          	blez	a4,80006ae6 <.L__fixsfsi_overflow_result>
80006ad4:	0522                	slli	a0,a0,0x8
80006ad6:	8d55                	or	a0,a0,a3
80006ad8:	00e55533          	srl	a0,a0,a4
80006adc:	8d3d                	xor	a0,a0,a5
80006ade:	8d1d                	sub	a0,a0,a5
80006ae0:	8082                	ret

80006ae2 <.L__fixsfsi_zero_result>:
80006ae2:	4501                	li	a0,0
80006ae4:	8082                	ret

80006ae6 <.L__fixsfsi_overflow_result>:
80006ae6:	fff6c713          	not	a4,a3
80006aea:	ff0005b7          	lui	a1,0xff000
80006aee:	00c5f363          	bgeu	a1,a2,80006af4 <.L__fixsfsi_not_nan>
80006af2:	8d79                	and	a0,a0,a4

80006af4 <.L__fixsfsi_not_nan>:
80006af4:	8d75                	and	a0,a0,a3
80006af6:	00054363          	bltz	a0,80006afc <.L__fixsfsi_done>
80006afa:	853a                	mv	a0,a4

80006afc <.L__fixsfsi_done>:
80006afc:	8082                	ret

Disassembly of section .text.libc.__fixunssfsi:

80006afe <__fixunssfsi>:
80006afe:	02a05763          	blez	a0,80006b2c <.L__fixunssfsi_zero_result>
80006b02:	00151593          	slli	a1,a0,0x1
80006b06:	81e1                	srli	a1,a1,0x18
80006b08:	f8158593          	addi	a1,a1,-127 # feffff81 <__AHB_SRAM_segment_end__+0xedf7f81>
80006b0c:	0205c063          	bltz	a1,80006b2c <.L__fixunssfsi_zero_result>
80006b10:	40b005b3          	neg	a1,a1
80006b14:	05fd                	addi	a1,a1,31
80006b16:	0005c963          	bltz	a1,80006b28 <.L__fixunssfsi_max_result>
80006b1a:	0522                	slli	a0,a0,0x8
80006b1c:	800006b7          	lui	a3,0x80000
80006b20:	8d55                	or	a0,a0,a3
80006b22:	00b55533          	srl	a0,a0,a1
80006b26:	8082                	ret

80006b28 <.L__fixunssfsi_max_result>:
80006b28:	557d                	li	a0,-1
80006b2a:	8082                	ret

80006b2c <.L__fixunssfsi_zero_result>:
80006b2c:	4501                	li	a0,0
80006b2e:	8082                	ret

Disassembly of section .text.libc.__floatsisf:

80006b30 <__floatsisf>:
80006b30:	01f55613          	srli	a2,a0,0x1f
80006b34:	0622                	slli	a2,a2,0x8
80006b36:	09d60613          	addi	a2,a2,157 # ff00009d <__AHB_SRAM_segment_end__+0xedf809d>
80006b3a:	cd29                	beqz	a0,80006b94 <.L__floatsisf_done>
80006b3c:	41f55693          	srai	a3,a0,0x1f
80006b40:	00d545b3          	xor	a1,a0,a3
80006b44:	8d95                	sub	a1,a1,a3
80006b46:	0105d693          	srli	a3,a1,0x10
80006b4a:	e299                	bnez	a3,80006b50 <.Ltmp5>
80006b4c:	05c2                	slli	a1,a1,0x10
80006b4e:	1641                	addi	a2,a2,-16

80006b50 <.Ltmp5>:
80006b50:	0185d693          	srli	a3,a1,0x18
80006b54:	e299                	bnez	a3,80006b5a <.Ltmp6>
80006b56:	05a2                	slli	a1,a1,0x8
80006b58:	1661                	addi	a2,a2,-8

80006b5a <.Ltmp6>:
80006b5a:	01c5d693          	srli	a3,a1,0x1c
80006b5e:	e299                	bnez	a3,80006b64 <.Ltmp7>
80006b60:	0592                	slli	a1,a1,0x4
80006b62:	1671                	addi	a2,a2,-4

80006b64 <.Ltmp7>:
80006b64:	01e5d693          	srli	a3,a1,0x1e
80006b68:	e299                	bnez	a3,80006b6e <.Ltmp8>
80006b6a:	058a                	slli	a1,a1,0x2
80006b6c:	1679                	addi	a2,a2,-2

80006b6e <.Ltmp8>:
80006b6e:	0005c463          	bltz	a1,80006b76 <.Ltmp9>
80006b72:	0586                	slli	a1,a1,0x1
80006b74:	167d                	addi	a2,a2,-1

80006b76 <.Ltmp9>:
80006b76:	065e                	slli	a2,a2,0x17
80006b78:	0085d513          	srli	a0,a1,0x8
80006b7c:	05de                	slli	a1,a1,0x17
80006b7e:	0005a333          	sltz	t1,a1
80006b82:	95ae                	add	a1,a1,a1
80006b84:	959a                	add	a1,a1,t1
80006b86:	0005d663          	bgez	a1,80006b92 <.L__floatsisf_round_down>
80006b8a:	95ae                	add	a1,a1,a1
80006b8c:	00b035b3          	snez	a1,a1
80006b90:	952e                	add	a0,a0,a1

80006b92 <.L__floatsisf_round_down>:
80006b92:	9532                	add	a0,a0,a2

80006b94 <.L__floatsisf_done>:
80006b94:	8082                	ret

Disassembly of section .text.libc.__floatunsisf:

80006b96 <__floatunsisf>:
80006b96:	c931                	beqz	a0,80006bea <.L__floatunsisf_done>
80006b98:	09d00613          	li	a2,157
80006b9c:	01055693          	srli	a3,a0,0x10
80006ba0:	e299                	bnez	a3,80006ba6 <.Ltmp35>
80006ba2:	0542                	slli	a0,a0,0x10
80006ba4:	1641                	addi	a2,a2,-16

80006ba6 <.Ltmp35>:
80006ba6:	01855693          	srli	a3,a0,0x18
80006baa:	e299                	bnez	a3,80006bb0 <.Ltmp36>
80006bac:	0522                	slli	a0,a0,0x8
80006bae:	1661                	addi	a2,a2,-8

80006bb0 <.Ltmp36>:
80006bb0:	01c55693          	srli	a3,a0,0x1c
80006bb4:	e299                	bnez	a3,80006bba <.Ltmp37>
80006bb6:	0512                	slli	a0,a0,0x4
80006bb8:	1671                	addi	a2,a2,-4

80006bba <.Ltmp37>:
80006bba:	01e55693          	srli	a3,a0,0x1e
80006bbe:	e299                	bnez	a3,80006bc4 <.Ltmp38>
80006bc0:	050a                	slli	a0,a0,0x2
80006bc2:	1679                	addi	a2,a2,-2

80006bc4 <.Ltmp38>:
80006bc4:	00054463          	bltz	a0,80006bcc <.Ltmp39>
80006bc8:	0506                	slli	a0,a0,0x1
80006bca:	167d                	addi	a2,a2,-1

80006bcc <.Ltmp39>:
80006bcc:	065e                	slli	a2,a2,0x17
80006bce:	01751593          	slli	a1,a0,0x17
80006bd2:	8121                	srli	a0,a0,0x8
80006bd4:	0005a333          	sltz	t1,a1
80006bd8:	95ae                	add	a1,a1,a1
80006bda:	959a                	add	a1,a1,t1
80006bdc:	0005d663          	bgez	a1,80006be8 <.L__floatunsisf_round_down>
80006be0:	95ae                	add	a1,a1,a1
80006be2:	00b035b3          	snez	a1,a1
80006be6:	952e                	add	a0,a0,a1

80006be8 <.L__floatunsisf_round_down>:
80006be8:	9532                	add	a0,a0,a2

80006bea <.L__floatunsisf_done>:
80006bea:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

80006bec <__floatundisf>:
80006bec:	c5bd                	beqz	a1,80006c5a <.L__floatundisf_high_word_zero>
80006bee:	4701                	li	a4,0
80006bf0:	0105d693          	srli	a3,a1,0x10
80006bf4:	e299                	bnez	a3,80006bfa <.Ltmp45>
80006bf6:	0741                	addi	a4,a4,16
80006bf8:	05c2                	slli	a1,a1,0x10

80006bfa <.Ltmp45>:
80006bfa:	0185d693          	srli	a3,a1,0x18
80006bfe:	e299                	bnez	a3,80006c04 <.Ltmp46>
80006c00:	0721                	addi	a4,a4,8
80006c02:	05a2                	slli	a1,a1,0x8

80006c04 <.Ltmp46>:
80006c04:	01c5d693          	srli	a3,a1,0x1c
80006c08:	e299                	bnez	a3,80006c0e <.Ltmp47>
80006c0a:	0711                	addi	a4,a4,4
80006c0c:	0592                	slli	a1,a1,0x4

80006c0e <.Ltmp47>:
80006c0e:	01e5d693          	srli	a3,a1,0x1e
80006c12:	e299                	bnez	a3,80006c18 <.Ltmp48>
80006c14:	0709                	addi	a4,a4,2
80006c16:	058a                	slli	a1,a1,0x2

80006c18 <.Ltmp48>:
80006c18:	0005c463          	bltz	a1,80006c20 <.Ltmp49>
80006c1c:	0705                	addi	a4,a4,1
80006c1e:	0586                	slli	a1,a1,0x1

80006c20 <.Ltmp49>:
80006c20:	fff74613          	not	a2,a4
80006c24:	00c556b3          	srl	a3,a0,a2
80006c28:	8285                	srli	a3,a3,0x1
80006c2a:	8dd5                	or	a1,a1,a3
80006c2c:	00e51533          	sll	a0,a0,a4
80006c30:	0be60613          	addi	a2,a2,190
80006c34:	00a03533          	snez	a0,a0
80006c38:	8dc9                	or	a1,a1,a0

80006c3a <.L__floatundisf_round_and_pack>:
80006c3a:	065e                	slli	a2,a2,0x17
80006c3c:	0085d513          	srli	a0,a1,0x8
80006c40:	05de                	slli	a1,a1,0x17
80006c42:	0005a333          	sltz	t1,a1
80006c46:	95ae                	add	a1,a1,a1
80006c48:	959a                	add	a1,a1,t1
80006c4a:	0005d663          	bgez	a1,80006c56 <.L__floatundisf_round_down>
80006c4e:	95ae                	add	a1,a1,a1
80006c50:	00b035b3          	snez	a1,a1
80006c54:	952e                	add	a0,a0,a1

80006c56 <.L__floatundisf_round_down>:
80006c56:	9532                	add	a0,a0,a2

80006c58 <.L__floatundisf_done>:
80006c58:	8082                	ret

80006c5a <.L__floatundisf_high_word_zero>:
80006c5a:	dd7d                	beqz	a0,80006c58 <.L__floatundisf_done>
80006c5c:	09d00613          	li	a2,157
80006c60:	01055693          	srli	a3,a0,0x10
80006c64:	e299                	bnez	a3,80006c6a <.Ltmp50>
80006c66:	0542                	slli	a0,a0,0x10
80006c68:	1641                	addi	a2,a2,-16

80006c6a <.Ltmp50>:
80006c6a:	01855693          	srli	a3,a0,0x18
80006c6e:	e299                	bnez	a3,80006c74 <.Ltmp51>
80006c70:	0522                	slli	a0,a0,0x8
80006c72:	1661                	addi	a2,a2,-8

80006c74 <.Ltmp51>:
80006c74:	01c55693          	srli	a3,a0,0x1c
80006c78:	e299                	bnez	a3,80006c7e <.Ltmp52>
80006c7a:	0512                	slli	a0,a0,0x4
80006c7c:	1671                	addi	a2,a2,-4

80006c7e <.Ltmp52>:
80006c7e:	01e55693          	srli	a3,a0,0x1e
80006c82:	e299                	bnez	a3,80006c88 <.Ltmp53>
80006c84:	050a                	slli	a0,a0,0x2
80006c86:	1679                	addi	a2,a2,-2

80006c88 <.Ltmp53>:
80006c88:	00054463          	bltz	a0,80006c90 <.Ltmp54>
80006c8c:	0506                	slli	a0,a0,0x1
80006c8e:	167d                	addi	a2,a2,-1

80006c90 <.Ltmp54>:
80006c90:	85aa                	mv	a1,a0
80006c92:	4501                	li	a0,0
80006c94:	b75d                	j	80006c3a <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

80006c96 <__truncdfsf2>:
80006c96:	00159693          	slli	a3,a1,0x1
80006c9a:	82d5                	srli	a3,a3,0x15
80006c9c:	7ff00613          	li	a2,2047
80006ca0:	04c68663          	beq	a3,a2,80006cec <.L__truncdfsf2_inf_nan>
80006ca4:	c8068693          	addi	a3,a3,-896 # 7ffffc80 <__NONCACHEABLE_RAM_segment_end__+0x7edbfc80>
80006ca8:	02d05e63          	blez	a3,80006ce4 <.L__truncdfsf2_underflow>
80006cac:	0ff00613          	li	a2,255
80006cb0:	04c6f263          	bgeu	a3,a2,80006cf4 <.L__truncdfsf2_inf>
80006cb4:	06de                	slli	a3,a3,0x17
80006cb6:	01f5d613          	srli	a2,a1,0x1f
80006cba:	067e                	slli	a2,a2,0x1f
80006cbc:	8ed1                	or	a3,a3,a2
80006cbe:	05b2                	slli	a1,a1,0xc
80006cc0:	01455613          	srli	a2,a0,0x14
80006cc4:	8dd1                	or	a1,a1,a2
80006cc6:	81a5                	srli	a1,a1,0x9
80006cc8:	00251613          	slli	a2,a0,0x2
80006ccc:	00062733          	sltz	a4,a2
80006cd0:	9632                	add	a2,a2,a2
80006cd2:	000627b3          	sltz	a5,a2
80006cd6:	9632                	add	a2,a2,a2
80006cd8:	963a                	add	a2,a2,a4
80006cda:	c211                	beqz	a2,80006cde <.L__truncdfsf2_no_round_tie>
80006cdc:	95be                	add	a1,a1,a5

80006cde <.L__truncdfsf2_no_round_tie>:
80006cde:	00d58533          	add	a0,a1,a3
80006ce2:	8082                	ret

80006ce4 <.L__truncdfsf2_underflow>:
80006ce4:	01f5d513          	srli	a0,a1,0x1f
80006ce8:	057e                	slli	a0,a0,0x1f
80006cea:	8082                	ret

80006cec <.L__truncdfsf2_inf_nan>:
80006cec:	00c59693          	slli	a3,a1,0xc
80006cf0:	8ec9                	or	a3,a3,a0
80006cf2:	ea81                	bnez	a3,80006d02 <.L__truncdfsf2_nan>

80006cf4 <.L__truncdfsf2_inf>:
80006cf4:	81fd                	srli	a1,a1,0x1f
80006cf6:	05fe                	slli	a1,a1,0x1f
80006cf8:	7f800537          	lui	a0,0x7f800
80006cfc:	8d4d                	or	a0,a0,a1
80006cfe:	4581                	li	a1,0
80006d00:	8082                	ret

80006d02 <.L__truncdfsf2_nan>:
80006d02:	800006b7          	lui	a3,0x80000
80006d06:	00d5f633          	and	a2,a1,a3
80006d0a:	058e                	slli	a1,a1,0x3
80006d0c:	8175                	srli	a0,a0,0x1d
80006d0e:	8d4d                	or	a0,a0,a1
80006d10:	0506                	slli	a0,a0,0x1
80006d12:	8105                	srli	a0,a0,0x1
80006d14:	8d51                	or	a0,a0,a2
80006d16:	82a5                	srli	a3,a3,0x9
80006d18:	8d55                	or	a0,a0,a3
80006d1a:	8082                	ret

Disassembly of section .text.libc.frexpf:

80006d1c <frexpf>:
80006d1c:	01755613          	srli	a2,a0,0x17
80006d20:	0ff67613          	zext.b	a2,a2
80006d24:	0ff00693          	li	a3,255
80006d28:	00d60363          	beq	a2,a3,80006d2e <frexpf+0x12>
80006d2c:	e601                	bnez	a2,80006d34 <frexpf+0x18>
80006d2e:	0005a023          	sw	zero,0(a1)
80006d32:	8082                	ret
80006d34:	f8260613          	addi	a2,a2,-126
80006d38:	c190                	sw	a2,0(a1)
80006d3a:	808005b7          	lui	a1,0x80800
80006d3e:	15fd                	addi	a1,a1,-1 # 807fffff <__FLASH_segment_end__+0x6fffff>
80006d40:	8d6d                	and	a0,a0,a1
80006d42:	3f0005b7          	lui	a1,0x3f000
80006d46:	8d4d                	or	a0,a0,a1
80006d48:	8082                	ret

Disassembly of section .text.libc.sqrtf:

80006d4a <sqrtf>:
80006d4a:	01755593          	srli	a1,a0,0x17
80006d4e:	15fd                	addi	a1,a1,-1 # 3effffff <__NONCACHEABLE_RAM_segment_end__+0x3ddbffff>
80006d50:	0fe00613          	li	a2,254
80006d54:	0cc5f063          	bgeu	a1,a2,80006e14 <sqrtf+0xca>
80006d58:	1101                	addi	sp,sp,-32
80006d5a:	ce06                	sw	ra,28(sp)
80006d5c:	cc22                	sw	s0,24(sp)
80006d5e:	ca26                	sw	s1,20(sp)
80006d60:	c84a                	sw	s2,16(sp)
80006d62:	c64e                	sw	s3,12(sp)
80006d64:	00851593          	slli	a1,a0,0x8
80006d68:	8000b637          	lui	a2,0x8000b
80006d6c:	0f060613          	addi	a2,a2,240 # 8000b0f0 <__SEGGER_RTL_aSqrtData>
80006d70:	81e1                	srli	a1,a1,0x18
80006d72:	00b606b3          	add	a3,a2,a1
80006d76:	8185                	srli	a1,a1,0x1
80006d78:	0006c683          	lbu	a3,0(a3) # 80000000 <__NONCACHEABLE_RAM_segment_end__+0x7edc0000>
80006d7c:	95b2                	add	a1,a1,a2
80006d7e:	1005c583          	lbu	a1,256(a1)
80006d82:	3e800937          	lui	s2,0x3e800
80006d86:	06c2                	slli	a3,a3,0x10
80006d88:	01268433          	add	s0,a3,s2
80006d8c:	05c2                	slli	a1,a1,0x10
80006d8e:	992e                	add	s2,s2,a1
80006d90:	002c                	addi	a1,sp,8
80006d92:	3769                	jal	80006d1c <frexpf>
80006d94:	49a2                	lw	s3,8(sp)
80006d96:	0019f593          	andi	a1,s3,1
80006d9a:	84aa                	mv	s1,a0
80006d9c:	c989                	beqz	a1,80006dae <sqrtf+0x64>
80006d9e:	55fd                	li	a1,-1
80006da0:	8526                	mv	a0,s1
80006da2:	544030ef          	jal	8000a2e6 <ldexpf>
80006da6:	84aa                	mv	s1,a0
80006da8:	49a2                	lw	s3,8(sp)
80006daa:	0985                	addi	s3,s3,1
80006dac:	c44e                	sw	s3,8(sp)
80006dae:	8522                	mv	a0,s0
80006db0:	85a2                	mv	a1,s0
80006db2:	23e030ef          	jal	80009ff0 <__mulsf3>
80006db6:	85aa                	mv	a1,a0
80006db8:	8526                	mv	a0,s1
80006dba:	3495                	jal	8000681e <__subsf3>
80006dbc:	85ca                	mv	a1,s2
80006dbe:	232030ef          	jal	80009ff0 <__mulsf3>
80006dc2:	85a2                	mv	a1,s0
80006dc4:	348d                	jal	80006826 <__addsf3>
80006dc6:	842a                	mv	s0,a0
80006dc8:	85aa                	mv	a1,a0
80006dca:	226030ef          	jal	80009ff0 <__mulsf3>
80006dce:	85aa                	mv	a1,a0
80006dd0:	8526                	mv	a0,s1
80006dd2:	34b1                	jal	8000681e <__subsf3>
80006dd4:	85ca                	mv	a1,s2
80006dd6:	21a030ef          	jal	80009ff0 <__mulsf3>
80006dda:	85aa                	mv	a1,a0
80006ddc:	8522                	mv	a0,s0
80006dde:	34a1                	jal	80006826 <__addsf3>
80006de0:	842a                	mv	s0,a0
80006de2:	85aa                	mv	a1,a0
80006de4:	20c030ef          	jal	80009ff0 <__mulsf3>
80006de8:	85aa                	mv	a1,a0
80006dea:	8526                	mv	a0,s1
80006dec:	3c0d                	jal	8000681e <__subsf3>
80006dee:	85ca                	mv	a1,s2
80006df0:	200030ef          	jal	80009ff0 <__mulsf3>
80006df4:	85aa                	mv	a1,a0
80006df6:	8522                	mv	a0,s0
80006df8:	343d                	jal	80006826 <__addsf3>
80006dfa:	01f9d593          	srli	a1,s3,0x1f
80006dfe:	95ce                	add	a1,a1,s3
80006e00:	8585                	srai	a1,a1,0x1
80006e02:	4e4030ef          	jal	8000a2e6 <ldexpf>
80006e06:	40f2                	lw	ra,28(sp)
80006e08:	4462                	lw	s0,24(sp)
80006e0a:	44d2                	lw	s1,20(sp)
80006e0c:	4942                	lw	s2,16(sp)
80006e0e:	49b2                	lw	s3,12(sp)
80006e10:	6105                	addi	sp,sp,32
80006e12:	8082                	ret
80006e14:	7f8005b7          	lui	a1,0x7f800
80006e18:	8de9                	and	a1,a1,a0
80006e1a:	c591                	beqz	a1,80006e26 <sqrtf+0xdc>
80006e1c:	fe055be3          	bgez	a0,80006e12 <sqrtf+0xc8>
80006e20:	7fc00537          	lui	a0,0x7fc00
80006e24:	8082                	ret
80006e26:	800005b7          	lui	a1,0x80000
80006e2a:	8d6d                	and	a0,a0,a1
80006e2c:	8082                	ret

Disassembly of section .text.libc.abs:

80006e2e <abs>:
80006e2e:	41f55593          	srai	a1,a0,0x1f
80006e32:	8d2d                	xor	a0,a0,a1
80006e34:	8d0d                	sub	a0,a0,a1
80006e36:	8082                	ret

Disassembly of section .text.libc.memcpy:

80006e38 <memcpy>:
80006e38:	c251                	beqz	a2,80006ebc <.Lmemcpy_done>
80006e3a:	87aa                	mv	a5,a0
80006e3c:	00b546b3          	xor	a3,a0,a1
80006e40:	06fa                	slli	a3,a3,0x1e
80006e42:	e2bd                	bnez	a3,80006ea8 <.Lmemcpy_byte_copy>
80006e44:	01e51693          	slli	a3,a0,0x1e
80006e48:	ce81                	beqz	a3,80006e60 <.Lmemcpy_aligned>

80006e4a <.Lmemcpy_word_align>:
80006e4a:	00058683          	lb	a3,0(a1) # 80000000 <__NONCACHEABLE_RAM_segment_end__+0x7edc0000>
80006e4e:	00d50023          	sb	a3,0(a0) # 7fc00000 <__NONCACHEABLE_RAM_segment_end__+0x7e9c0000>
80006e52:	0585                	addi	a1,a1,1
80006e54:	0505                	addi	a0,a0,1
80006e56:	167d                	addi	a2,a2,-1
80006e58:	c22d                	beqz	a2,80006eba <.Lmemcpy_memcpy_end>
80006e5a:	01e51693          	slli	a3,a0,0x1e
80006e5e:	f6f5                	bnez	a3,80006e4a <.Lmemcpy_word_align>

80006e60 <.Lmemcpy_aligned>:
80006e60:	02000693          	li	a3,32
80006e64:	02d66763          	bltu	a2,a3,80006e92 <.Lmemcpy_word_copy>

80006e68 <.Lmemcpy_aligned_block_copy_loop>:
80006e68:	4198                	lw	a4,0(a1)
80006e6a:	c118                	sw	a4,0(a0)
80006e6c:	41d8                	lw	a4,4(a1)
80006e6e:	c158                	sw	a4,4(a0)
80006e70:	4598                	lw	a4,8(a1)
80006e72:	c518                	sw	a4,8(a0)
80006e74:	45d8                	lw	a4,12(a1)
80006e76:	c558                	sw	a4,12(a0)
80006e78:	4998                	lw	a4,16(a1)
80006e7a:	c918                	sw	a4,16(a0)
80006e7c:	49d8                	lw	a4,20(a1)
80006e7e:	c958                	sw	a4,20(a0)
80006e80:	4d98                	lw	a4,24(a1)
80006e82:	cd18                	sw	a4,24(a0)
80006e84:	4dd8                	lw	a4,28(a1)
80006e86:	cd58                	sw	a4,28(a0)
80006e88:	9536                	add	a0,a0,a3
80006e8a:	95b6                	add	a1,a1,a3
80006e8c:	8e15                	sub	a2,a2,a3
80006e8e:	fcd67de3          	bgeu	a2,a3,80006e68 <.Lmemcpy_aligned_block_copy_loop>

80006e92 <.Lmemcpy_word_copy>:
80006e92:	c605                	beqz	a2,80006eba <.Lmemcpy_memcpy_end>
80006e94:	4691                	li	a3,4
80006e96:	00d66963          	bltu	a2,a3,80006ea8 <.Lmemcpy_byte_copy>

80006e9a <.Lmemcpy_word_copy_loop>:
80006e9a:	4198                	lw	a4,0(a1)
80006e9c:	c118                	sw	a4,0(a0)
80006e9e:	9536                	add	a0,a0,a3
80006ea0:	95b6                	add	a1,a1,a3
80006ea2:	8e15                	sub	a2,a2,a3
80006ea4:	fed67be3          	bgeu	a2,a3,80006e9a <.Lmemcpy_word_copy_loop>

80006ea8 <.Lmemcpy_byte_copy>:
80006ea8:	ca09                	beqz	a2,80006eba <.Lmemcpy_memcpy_end>

80006eaa <.Lmemcpy_byte_copy_loop>:
80006eaa:	00058703          	lb	a4,0(a1)
80006eae:	00e50023          	sb	a4,0(a0)
80006eb2:	0585                	addi	a1,a1,1
80006eb4:	0505                	addi	a0,a0,1
80006eb6:	167d                	addi	a2,a2,-1
80006eb8:	fa6d                	bnez	a2,80006eaa <.Lmemcpy_byte_copy_loop>

80006eba <.Lmemcpy_memcpy_end>:
80006eba:	853e                	mv	a0,a5

80006ebc <.Lmemcpy_done>:
80006ebc:	8082                	ret

Disassembly of section .text.libc.strnlen:

80006ebe <strnlen>:
80006ebe:	cda9                	beqz	a1,80006f18 <strnlen+0x5a>
80006ec0:	00054603          	lbu	a2,0(a0)
80006ec4:	ca31                	beqz	a2,80006f18 <strnlen+0x5a>
80006ec6:	ffc57713          	andi	a4,a0,-4
80006eca:	00357613          	andi	a2,a0,3
80006ece:	00351693          	slli	a3,a0,0x3
80006ed2:	95b2                	add	a1,a1,a2
80006ed4:	4310                	lw	a2,0(a4)
80006ed6:	57fd                	li	a5,-1
80006ed8:	00d796b3          	sll	a3,a5,a3
80006edc:	fff6c693          	not	a3,a3
80006ee0:	4791                	li	a5,4
80006ee2:	8ed1                	or	a3,a3,a2
80006ee4:	02f5ed63          	bltu	a1,a5,80006f1e <strnlen+0x60>
80006ee8:	01010637          	lui	a2,0x1010
80006eec:	808087b7          	lui	a5,0x80808
80006ef0:	10060893          	addi	a7,a2,256 # 1010100 <__DLM_segment_end__+0xdf0100>
80006ef4:	08078793          	addi	a5,a5,128 # 80808080 <__FLASH_segment_end__+0x708080>
80006ef8:	480d                	li	a6,3
80006efa:	863a                	mv	a2,a4
80006efc:	40d88733          	sub	a4,a7,a3
80006f00:	8f55                	or	a4,a4,a3
80006f02:	8f7d                	and	a4,a4,a5
80006f04:	00f71c63          	bne	a4,a5,80006f1c <strnlen+0x5e>
80006f08:	4254                	lw	a3,4(a2)
80006f0a:	00460713          	addi	a4,a2,4
80006f0e:	15f1                	addi	a1,a1,-4
80006f10:	863a                	mv	a2,a4
80006f12:	feb865e3          	bltu	a6,a1,80006efc <strnlen+0x3e>
80006f16:	a021                	j	80006f1e <strnlen+0x60>
80006f18:	4501                	li	a0,0
80006f1a:	8082                	ret
80006f1c:	8732                	mv	a4,a2
80006f1e:	0ff6f613          	zext.b	a2,a3
80006f22:	c215                	beqz	a2,80006f46 <strnlen+0x88>
80006f24:	6641                	lui	a2,0x10
80006f26:	f0060613          	addi	a2,a2,-256 # ff00 <__FLASH_segment_used_size__+0x750c>
80006f2a:	8e75                	and	a2,a2,a3
80006f2c:	ce01                	beqz	a2,80006f44 <strnlen+0x86>
80006f2e:	00ff0637          	lui	a2,0xff0
80006f32:	8e75                	and	a2,a2,a3
80006f34:	c205                	beqz	a2,80006f54 <strnlen+0x96>
80006f36:	82e1                	srli	a3,a3,0x18
80006f38:	00d03633          	snez	a2,a3
80006f3c:	060d                	addi	a2,a2,3 # ff0003 <__DLM_segment_end__+0xdd0003>
80006f3e:	00b67663          	bgeu	a2,a1,80006f4a <strnlen+0x8c>
80006f42:	a029                	j	80006f4c <strnlen+0x8e>
80006f44:	4605                	li	a2,1
80006f46:	00b66363          	bltu	a2,a1,80006f4c <strnlen+0x8e>
80006f4a:	862e                	mv	a2,a1
80006f4c:	40a70533          	sub	a0,a4,a0
80006f50:	9532                	add	a0,a0,a2
80006f52:	8082                	ret
80006f54:	4609                	li	a2,2
80006f56:	feb67ae3          	bgeu	a2,a1,80006f4a <strnlen+0x8c>
80006f5a:	bfcd                	j	80006f4c <strnlen+0x8e>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

80006f5c <__SEGGER_RTL_putc>:
80006f5c:	1141                	addi	sp,sp,-16
80006f5e:	c606                	sw	ra,12(sp)
80006f60:	c422                	sw	s0,8(sp)
80006f62:	842a                	mv	s0,a0
80006f64:	4908                	lw	a0,16(a0)
80006f66:	00b103a3          	sb	a1,7(sp)
80006f6a:	c11d                	beqz	a0,80006f90 <__SEGGER_RTL_putc+0x34>
80006f6c:	4010                	lw	a2,0(s0)
80006f6e:	4054                	lw	a3,4(s0)
80006f70:	06d67f63          	bgeu	a2,a3,80006fee <__SEGGER_RTL_putc+0x92>
80006f74:	4850                	lw	a2,20(s0)
80006f76:	00160693          	addi	a3,a2,1
80006f7a:	9532                	add	a0,a0,a2
80006f7c:	c854                	sw	a3,20(s0)
80006f7e:	00b50023          	sb	a1,0(a0)
80006f82:	4848                	lw	a0,20(s0)
80006f84:	4c0c                	lw	a1,24(s0)
80006f86:	06b51463          	bne	a0,a1,80006fee <__SEGGER_RTL_putc+0x92>
80006f8a:	8522                	mv	a0,s0
80006f8c:	2885                	jal	80006ffc <__SEGGER_RTL_prin_flush>
80006f8e:	a085                	j	80006fee <__SEGGER_RTL_putc+0x92>
80006f90:	4448                	lw	a0,12(s0)
80006f92:	c105                	beqz	a0,80006fb2 <__SEGGER_RTL_putc+0x56>
80006f94:	4010                	lw	a2,0(s0)
80006f96:	4054                	lw	a3,4(s0)
80006f98:	04d67b63          	bgeu	a2,a3,80006fee <__SEGGER_RTL_putc+0x92>
80006f9c:	00160713          	addi	a4,a2,1
80006fa0:	8eb9                	xor	a3,a3,a4
80006fa2:	0016b693          	seqz	a3,a3
80006fa6:	16fd                	addi	a3,a3,-1
80006fa8:	8df5                	and	a1,a1,a3
80006faa:	9532                	add	a0,a0,a2
80006fac:	00b50023          	sb	a1,0(a0)
80006fb0:	a83d                	j	80006fee <__SEGGER_RTL_putc+0x92>
80006fb2:	4408                	lw	a0,8(s0)
80006fb4:	c115                	beqz	a0,80006fd8 <__SEGGER_RTL_putc+0x7c>
80006fb6:	4010                	lw	a2,0(s0)
80006fb8:	4054                	lw	a3,4(s0)
80006fba:	02d67a63          	bgeu	a2,a3,80006fee <__SEGGER_RTL_putc+0x92>
80006fbe:	00160713          	addi	a4,a2,1
80006fc2:	060a                	slli	a2,a2,0x2
80006fc4:	8eb9                	xor	a3,a3,a4
80006fc6:	0016b693          	seqz	a3,a3
80006fca:	16fd                	addi	a3,a3,-1
80006fcc:	8df5                	and	a1,a1,a3
80006fce:	0ff5f593          	zext.b	a1,a1
80006fd2:	9532                	add	a0,a0,a2
80006fd4:	c10c                	sw	a1,0(a0)
80006fd6:	a821                	j	80006fee <__SEGGER_RTL_putc+0x92>
80006fd8:	5014                	lw	a3,32(s0)
80006fda:	ca91                	beqz	a3,80006fee <__SEGGER_RTL_putc+0x92>
80006fdc:	4008                	lw	a0,0(s0)
80006fde:	404c                	lw	a1,4(s0)
80006fe0:	00b57763          	bgeu	a0,a1,80006fee <__SEGGER_RTL_putc+0x92>
80006fe4:	00710593          	addi	a1,sp,7
80006fe8:	4605                	li	a2,1
80006fea:	8522                	mv	a0,s0
80006fec:	9682                	jalr	a3
80006fee:	4008                	lw	a0,0(s0)
80006ff0:	0505                	addi	a0,a0,1
80006ff2:	c008                	sw	a0,0(s0)
80006ff4:	40b2                	lw	ra,12(sp)
80006ff6:	4422                	lw	s0,8(sp)
80006ff8:	0141                	addi	sp,sp,16
80006ffa:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

80006ffc <__SEGGER_RTL_prin_flush>:
80006ffc:	4950                	lw	a2,20(a0)
80006ffe:	ce19                	beqz	a2,8000701c <__SEGGER_RTL_prin_flush+0x20>
80007000:	1141                	addi	sp,sp,-16
80007002:	c606                	sw	ra,12(sp)
80007004:	c422                	sw	s0,8(sp)
80007006:	842a                	mv	s0,a0
80007008:	5114                	lw	a3,32(a0)
8000700a:	c681                	beqz	a3,80007012 <__SEGGER_RTL_prin_flush+0x16>
8000700c:	480c                	lw	a1,16(s0)
8000700e:	8522                	mv	a0,s0
80007010:	9682                	jalr	a3
80007012:	00042a23          	sw	zero,20(s0)
80007016:	40b2                	lw	ra,12(sp)
80007018:	4422                	lw	s0,8(sp)
8000701a:	0141                	addi	sp,sp,16
8000701c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

8000701e <__SEGGER_RTL_print_padding>:
8000701e:	02c05963          	blez	a2,80007050 <__SEGGER_RTL_print_padding+0x32>
80007022:	1101                	addi	sp,sp,-32
80007024:	ce06                	sw	ra,28(sp)
80007026:	cc22                	sw	s0,24(sp)
80007028:	ca26                	sw	s1,20(sp)
8000702a:	c84a                	sw	s2,16(sp)
8000702c:	c64e                	sw	s3,12(sp)
8000702e:	892e                	mv	s2,a1
80007030:	84aa                	mv	s1,a0
80007032:	00160413          	addi	s0,a2,1
80007036:	4985                	li	s3,1
80007038:	8526                	mv	a0,s1
8000703a:	85ca                	mv	a1,s2
8000703c:	3705                	jal	80006f5c <__SEGGER_RTL_putc>
8000703e:	147d                	addi	s0,s0,-1
80007040:	fe89ece3          	bltu	s3,s0,80007038 <__SEGGER_RTL_print_padding+0x1a>
80007044:	40f2                	lw	ra,28(sp)
80007046:	4462                	lw	s0,24(sp)
80007048:	44d2                	lw	s1,20(sp)
8000704a:	4942                	lw	s2,16(sp)
8000704c:	49b2                	lw	s3,12(sp)
8000704e:	6105                	addi	sp,sp,32
80007050:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

80007052 <__SEGGER_RTL_pre_padding>:
80007052:	0105f693          	andi	a3,a1,16
80007056:	e699                	bnez	a3,80007064 <__SEGGER_RTL_pre_padding+0x12>
80007058:	2005f593          	andi	a1,a1,512
8000705c:	c589                	beqz	a1,80007066 <__SEGGER_RTL_pre_padding+0x14>
8000705e:	03000593          	li	a1,48
80007062:	bf75                	j	8000701e <__SEGGER_RTL_print_padding>
80007064:	8082                	ret
80007066:	02000593          	li	a1,32
8000706a:	bf55                	j	8000701e <__SEGGER_RTL_print_padding>

Disassembly of section .text.libc.vfprintf:

8000706c <vfprintf>:
8000706c:	1141                	addi	sp,sp,-16
8000706e:	c606                	sw	ra,12(sp)
80007070:	c422                	sw	s0,8(sp)
80007072:	c226                	sw	s1,4(sp)
80007074:	c04a                	sw	s2,0(sp)
80007076:	8932                	mv	s2,a2
80007078:	84ae                	mv	s1,a1
8000707a:	842a                	mv	s0,a0
8000707c:	67b030ef          	jal	8000aef6 <__SEGGER_RTL_current_locale>
80007080:	85aa                	mv	a1,a0
80007082:	8522                	mv	a0,s0
80007084:	8626                	mv	a2,s1
80007086:	86ca                	mv	a3,s2
80007088:	40b2                	lw	ra,12(sp)
8000708a:	4422                	lw	s0,8(sp)
8000708c:	4492                	lw	s1,4(sp)
8000708e:	4902                	lw	s2,0(sp)
80007090:	0141                	addi	sp,sp,16
80007092:	a009                	j	80007094 <vfprintf_l>

Disassembly of section .text.libc.vfprintf_l:

80007094 <vfprintf_l>:
80007094:	619022ef          	jal	t0,80009eac <__riscv_save_10>
80007098:	7179                	addi	sp,sp,-48
8000709a:	1080                	addi	s0,sp,96
8000709c:	8936                	mv	s2,a3
8000709e:	89b2                	mv	s3,a2
800070a0:	8a2e                	mv	s4,a1
800070a2:	8aaa                	mv	s5,a0
800070a4:	5f5020ef          	jal	80009e98 <__SEGGER_RTL_X_file_bufsize>
800070a8:	8baa                	mv	s7,a0
800070aa:	8b0a                	mv	s6,sp
800070ac:	053d                	addi	a0,a0,15
800070ae:	9941                	andi	a0,a0,-16
800070b0:	40a104b3          	sub	s1,sp,a0
800070b4:	8126                	mv	sp,s1
800070b6:	fa840513          	addi	a0,s0,-88
800070ba:	02400613          	li	a2,36
800070be:	4581                	li	a1,0
800070c0:	50b030ef          	jal	8000adca <memset>
800070c4:	80000537          	lui	a0,0x80000
800070c8:	800075b7          	lui	a1,0x80007
800070cc:	10058593          	addi	a1,a1,256 # 80007100 <__SEGGER_RTL_stream_write>
800070d0:	157d                	addi	a0,a0,-1 # 7fffffff <__NONCACHEABLE_RAM_segment_end__+0x7edbffff>
800070d2:	faa42623          	sw	a0,-84(s0)
800070d6:	fa942c23          	sw	s1,-72(s0)
800070da:	fd742023          	sw	s7,-64(s0)
800070de:	fd442223          	sw	s4,-60(s0)
800070e2:	fcb42423          	sw	a1,-56(s0)
800070e6:	fd542623          	sw	s5,-52(s0)
800070ea:	fa840513          	addi	a0,s0,-88
800070ee:	85ce                	mv	a1,s3
800070f0:	864a                	mv	a2,s2
800070f2:	2091                	jal	80007136 <__SEGGER_RTL_vfprintf>
800070f4:	815a                	mv	sp,s6
800070f6:	fa040113          	addi	sp,s0,-96
800070fa:	6145                	addi	sp,sp,48
800070fc:	5e30206f          	j	80009ede <__riscv_restore_8>

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

80007100 <__SEGGER_RTL_stream_write>:
80007100:	5154                	lw	a3,36(a0)
80007102:	852e                	mv	a0,a1
80007104:	4585                	li	a1,1
80007106:	6a70206f          	j	80009fac <fwrite>

Disassembly of section .text.libc.printf:

8000710a <printf>:
8000710a:	7179                	addi	sp,sp,-48
8000710c:	c606                	sw	ra,12(sp)
8000710e:	82aa                	mv	t0,a0
80007110:	d23e                	sw	a5,36(sp)
80007112:	d442                	sw	a6,40(sp)
80007114:	d646                	sw	a7,44(sp)
80007116:	01200537          	lui	a0,0x1200
8000711a:	05452503          	lw	a0,84(a0) # 1200054 <stdout>
8000711e:	ca2e                	sw	a1,20(sp)
80007120:	cc32                	sw	a2,24(sp)
80007122:	ce36                	sw	a3,28(sp)
80007124:	d03a                	sw	a4,32(sp)
80007126:	084c                	addi	a1,sp,20
80007128:	c42e                	sw	a1,8(sp)
8000712a:	0850                	addi	a2,sp,20
8000712c:	8596                	mv	a1,t0
8000712e:	3f3d                	jal	8000706c <vfprintf>
80007130:	40b2                	lw	ra,12(sp)
80007132:	6145                	addi	sp,sp,48
80007134:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

80007136 <__SEGGER_RTL_vfprintf>:
80007136:	56f022ef          	jal	t0,80009ea4 <__riscv_save_12>
8000713a:	711d                	addi	sp,sp,-96
8000713c:	8d2e                	mv	s10,a1
8000713e:	8a2a                	mv	s4,a0
80007140:	448d                	li	s1,3
80007142:	00052023          	sw	zero,0(a0)
80007146:	02500c93          	li	s9,37
8000714a:	4dc1                	li	s11,16
8000714c:	49a9                	li	s3,10
8000714e:	66666537          	lui	a0,0x66666
80007152:	7e9675b7          	lui	a1,0x7e967
80007156:	747d                	lui	s0,0xfffff
80007158:	555556b7          	lui	a3,0x55555
8000715c:	51eb8737          	lui	a4,0x51eb8
80007160:	000207b7          	lui	a5,0x20
80007164:	66750513          	addi	a0,a0,1639 # 66666667 <__NONCACHEABLE_RAM_segment_end__+0x65426667>
80007168:	cc2a                	sw	a0,24(sp)
8000716a:	69958513          	addi	a0,a1,1689 # 7e967699 <__NONCACHEABLE_RAM_segment_end__+0x7d727699>
8000716e:	c62a                	sw	a0,12(sp)
80007170:	7ff40513          	addi	a0,s0,2047 # fffff7ff <__AHB_SRAM_segment_end__+0xfdf77ff>
80007174:	c82a                	sw	a0,16(sp)
80007176:	55668513          	addi	a0,a3,1366 # 55555556 <__NONCACHEABLE_RAM_segment_end__+0x54315556>
8000717a:	c02a                	sw	a0,0(sp)
8000717c:	51f70513          	addi	a0,a4,1311 # 51eb851f <__NONCACHEABLE_RAM_segment_end__+0x50c7851f>
80007180:	c42a                	sw	a0,8(sp)
80007182:	02178513          	addi	a0,a5,33 # 20021 <__DLM_segment_size__+0x21>
80007186:	ce2a                	sw	a0,28(sp)
80007188:	4505                	li	a0,1
8000718a:	04aa                	slli	s1,s1,0xa
8000718c:	d026                	sw	s1,32(sp)
8000718e:	84b2                	mv	s1,a2
80007190:	052e                	slli	a0,a0,0xb
80007192:	c22a                	sw	a0,4(sp)
80007194:	c7418913          	addi	s2,gp,-908 # 80003da8 <.LJTI0_0>
80007198:	000d4583          	lbu	a1,0(s10)
8000719c:	01958863          	beq	a1,s9,800071ac <__SEGGER_RTL_vfprintf+0x76>
800071a0:	56058de3          	beqz	a1,80007f1a <__SEGGER_RTL_vfprintf+0xde4>
800071a4:	0d05                	addi	s10,s10,1
800071a6:	8552                	mv	a0,s4
800071a8:	3b55                	jal	80006f5c <__SEGGER_RTL_putc>
800071aa:	b7fd                	j	80007198 <__SEGGER_RTL_vfprintf+0x62>
800071ac:	4b81                	li	s7,0
800071ae:	0d0d                	addi	s10,s10,3
800071b0:	05e00693          	li	a3,94
800071b4:	ffed4503          	lbu	a0,-2(s10)
800071b8:	fe050593          	addi	a1,a0,-32
800071bc:	00bdeb63          	bltu	s11,a1,800071d2 <__SEGGER_RTL_vfprintf+0x9c>
800071c0:	058a                	slli	a1,a1,0x2
800071c2:	95ca                	add	a1,a1,s2
800071c4:	4190                	lw	a2,0(a1)
800071c6:	08000593          	li	a1,128
800071ca:	8602                	jr	a2
800071cc:	04000593          	li	a1,64
800071d0:	a831                	j	800071ec <__SEGGER_RTL_vfprintf+0xb6>
800071d2:	02d51163          	bne	a0,a3,800071f4 <__SEGGER_RTL_vfprintf+0xbe>
800071d6:	6585                	lui	a1,0x1
800071d8:	a811                	j	800071ec <__SEGGER_RTL_vfprintf+0xb6>
800071da:	45c1                	li	a1,16
800071dc:	a801                	j	800071ec <__SEGGER_RTL_vfprintf+0xb6>
800071de:	20000593          	li	a1,512
800071e2:	a029                	j	800071ec <__SEGGER_RTL_vfprintf+0xb6>
800071e4:	65a1                	lui	a1,0x8
800071e6:	a019                	j	800071ec <__SEGGER_RTL_vfprintf+0xb6>
800071e8:	02000593          	li	a1,32
800071ec:	00bbebb3          	or	s7,s7,a1
800071f0:	0d05                	addi	s10,s10,1
800071f2:	b7c9                	j	800071b4 <__SEGGER_RTL_vfprintf+0x7e>
800071f4:	fd050593          	addi	a1,a0,-48
800071f8:	0ff5f593          	zext.b	a1,a1
800071fc:	1d7d                	addi	s10,s10,-1
800071fe:	4625                	li	a2,9
80007200:	04b66263          	bltu	a2,a1,80007244 <__SEGGER_RTL_vfprintf+0x10e>
80007204:	4581                	li	a1,0
80007206:	0ff57613          	zext.b	a2,a0
8000720a:	000d4503          	lbu	a0,0(s10)
8000720e:	033585b3          	mul	a1,a1,s3
80007212:	95b2                	add	a1,a1,a2
80007214:	fd058593          	addi	a1,a1,-48 # 7fd0 <__HEAPSIZE__+0x3fd0>
80007218:	fd050613          	addi	a2,a0,-48
8000721c:	0ff67613          	zext.b	a2,a2
80007220:	0d05                	addi	s10,s10,1
80007222:	ff3662e3          	bltu	a2,s3,80007206 <__SEGGER_RTL_vfprintf+0xd0>
80007226:	a005                	j	80007246 <__SEGGER_RTL_vfprintf+0x110>
80007228:	408c                	lw	a1,0(s1)
8000722a:	0491                	addi	s1,s1,4
8000722c:	fffd4503          	lbu	a0,-1(s10)
80007230:	01b5d693          	srli	a3,a1,0x1b
80007234:	8ac1                	andi	a3,a3,16
80007236:	0176ebb3          	or	s7,a3,s7
8000723a:	41f5d693          	srai	a3,a1,0x1f
8000723e:	8db5                	xor	a1,a1,a3
80007240:	8d95                	sub	a1,a1,a3
80007242:	a011                	j	80007246 <__SEGGER_RTL_vfprintf+0x110>
80007244:	4581                	li	a1,0
80007246:	02e00613          	li	a2,46
8000724a:	00c51f63          	bne	a0,a2,80007268 <__SEGGER_RTL_vfprintf+0x132>
8000724e:	000d4503          	lbu	a0,0(s10)
80007252:	02a00613          	li	a2,42
80007256:	00c51b63          	bne	a0,a2,8000726c <__SEGGER_RTL_vfprintf+0x136>
8000725a:	0004ab03          	lw	s6,0(s1)
8000725e:	001d4503          	lbu	a0,1(s10)
80007262:	0491                	addi	s1,s1,4
80007264:	0d09                	addi	s10,s10,2
80007266:	a825                	j	8000729e <__SEGGER_RTL_vfprintf+0x168>
80007268:	4b01                	li	s6,0
8000726a:	a099                	j	800072b0 <__SEGGER_RTL_vfprintf+0x17a>
8000726c:	fd050613          	addi	a2,a0,-48
80007270:	0ff67613          	zext.b	a2,a2
80007274:	0d05                	addi	s10,s10,1
80007276:	4b01                	li	s6,0
80007278:	46a5                	li	a3,9
8000727a:	02c6e963          	bltu	a3,a2,800072ac <__SEGGER_RTL_vfprintf+0x176>
8000727e:	0ff57613          	zext.b	a2,a0
80007282:	000d4503          	lbu	a0,0(s10)
80007286:	033b06b3          	mul	a3,s6,s3
8000728a:	9636                	add	a2,a2,a3
8000728c:	fd060b13          	addi	s6,a2,-48
80007290:	fd050613          	addi	a2,a0,-48
80007294:	0ff67613          	zext.b	a2,a2
80007298:	0d05                	addi	s10,s10,1
8000729a:	ff3662e3          	bltu	a2,s3,8000727e <__SEGGER_RTL_vfprintf+0x148>
8000729e:	fffb4613          	not	a2,s6
800072a2:	827d                	srli	a2,a2,0x1f
800072a4:	0622                	slli	a2,a2,0x8
800072a6:	00cbebb3          	or	s7,s7,a2
800072aa:	a019                	j	800072b0 <__SEGGER_RTL_vfprintf+0x17a>
800072ac:	100beb93          	ori	s7,s7,256
800072b0:	f9850613          	addi	a2,a0,-104
800072b4:	00761693          	slli	a3,a2,0x7
800072b8:	0662                	slli	a2,a2,0x18
800072ba:	8265                	srli	a2,a2,0x19
800072bc:	8e55                	or	a2,a2,a3
800072be:	0ff67613          	zext.b	a2,a2
800072c2:	46a5                	li	a3,9
800072c4:	04c6ef63          	bltu	a3,a2,80007322 <__SEGGER_RTL_vfprintf+0x1ec>
800072c8:	060a                	slli	a2,a2,0x2
800072ca:	cb818693          	addi	a3,gp,-840 # 80003dec <.LJTI0_1>
800072ce:	9636                	add	a2,a2,a3
800072d0:	4210                	lw	a2,0(a2)
800072d2:	8602                	jr	a2
800072d4:	000d4503          	lbu	a0,0(s10)
800072d8:	0d05                	addi	s10,s10,1
800072da:	a0a1                	j	80007322 <__SEGGER_RTL_vfprintf+0x1ec>
800072dc:	000d4503          	lbu	a0,0(s10)
800072e0:	06c00613          	li	a2,108
800072e4:	02c51863          	bne	a0,a2,80007314 <__SEGGER_RTL_vfprintf+0x1de>
800072e8:	001d4503          	lbu	a0,1(s10)
800072ec:	0d09                	addi	s10,s10,2
800072ee:	a005                	j	8000730e <__SEGGER_RTL_vfprintf+0x1d8>
800072f0:	000d4503          	lbu	a0,0(s10)
800072f4:	06800613          	li	a2,104
800072f8:	02c51263          	bne	a0,a2,8000731c <__SEGGER_RTL_vfprintf+0x1e6>
800072fc:	001d4503          	lbu	a0,1(s10)
80007300:	0d09                	addi	s10,s10,2
80007302:	008beb93          	ori	s7,s7,8
80007306:	a831                	j	80007322 <__SEGGER_RTL_vfprintf+0x1ec>
80007308:	000d4503          	lbu	a0,0(s10)
8000730c:	0d05                	addi	s10,s10,1
8000730e:	002beb93          	ori	s7,s7,2
80007312:	a801                	j	80007322 <__SEGGER_RTL_vfprintf+0x1ec>
80007314:	0d05                	addi	s10,s10,1
80007316:	001beb93          	ori	s7,s7,1
8000731a:	a021                	j	80007322 <__SEGGER_RTL_vfprintf+0x1ec>
8000731c:	0d05                	addi	s10,s10,1
8000731e:	004beb93          	ori	s7,s7,4
80007322:	00b02633          	sgtz	a2,a1
80007326:	40c00633          	neg	a2,a2
8000732a:	00b67ab3          	and	s5,a2,a1
8000732e:	04600593          	li	a1,70
80007332:	02a5d363          	bge	a1,a0,80007358 <__SEGGER_RTL_vfprintf+0x222>
80007336:	f9d50593          	addi	a1,a0,-99
8000733a:	4655                	li	a2,21
8000733c:	04b66663          	bltu	a2,a1,80007388 <__SEGGER_RTL_vfprintf+0x252>
80007340:	058a                	slli	a1,a1,0x2
80007342:	ce018613          	addi	a2,gp,-800 # 80003e14 <.LJTI0_2>
80007346:	95b2                	add	a1,a1,a2
80007348:	418c                	lw	a1,0(a1)
8000734a:	8582                	jr	a1
8000734c:	d456                	sw	s5,40(sp)
8000734e:	d202                	sw	zero,36(sp)
80007350:	6591                	lui	a1,0x4
80007352:	00bbeab3          	or	s5,s7,a1
80007356:	a219                	j	8000745c <__SEGGER_RTL_vfprintf+0x326>
80007358:	04400593          	li	a1,68
8000735c:	02a5d163          	bge	a1,a0,8000737e <__SEGGER_RTL_vfprintf+0x248>
80007360:	04500593          	li	a1,69
80007364:	04b50663          	beq	a0,a1,800073b0 <__SEGGER_RTL_vfprintf+0x27a>
80007368:	04600593          	li	a1,70
8000736c:	e2b516e3          	bne	a0,a1,80007198 <__SEGGER_RTL_vfprintf+0x62>
80007370:	6509                	lui	a0,0x2
80007372:	00abebb3          	or	s7,s7,a0
80007376:	5502                	lw	a0,32(sp)
80007378:	c0050513          	addi	a0,a0,-1024 # 1c00 <__NONCACHEABLE_RAM_segment_used_size__+0xb40>
8000737c:	a4fd                	j	8000766a <__SEGGER_RTL_vfprintf+0x534>
8000737e:	5b951f63          	bne	a0,s9,8000793c <__SEGGER_RTL_vfprintf+0x806>
80007382:	02500593          	li	a1,37
80007386:	b505                	j	800071a6 <__SEGGER_RTL_vfprintf+0x70>
80007388:	04700593          	li	a1,71
8000738c:	2cb50b63          	beq	a0,a1,80007662 <__SEGGER_RTL_vfprintf+0x52c>
80007390:	05800593          	li	a1,88
80007394:	e0b512e3          	bne	a0,a1,80007198 <__SEGGER_RTL_vfprintf+0x62>
80007398:	6589                	lui	a1,0x2
8000739a:	00bbebb3          	or	s7,s7,a1
8000739e:	07800593          	li	a1,120
800073a2:	d456                	sw	s5,40(sp)
800073a4:	08b50e63          	beq	a0,a1,80007440 <__SEGGER_RTL_vfprintf+0x30a>
800073a8:	658d                	lui	a1,0x3
800073aa:	05858593          	addi	a1,a1,88 # 3058 <__BOOT_HEADER_segment_size__+0x1058>
800073ae:	a861                	j	80007446 <__SEGGER_RTL_vfprintf+0x310>
800073b0:	6509                	lui	a0,0x2
800073b2:	00abebb3          	or	s7,s7,a0
800073b6:	400bec93          	ori	s9,s7,1024
800073ba:	ac55                	j	8000766e <__SEGGER_RTL_vfprintf+0x538>
800073bc:	100bf593          	andi	a1,s7,256
800073c0:	d456                	sw	s5,40(sp)
800073c2:	c199                	beqz	a1,800073c8 <__SEGGER_RTL_vfprintf+0x292>
800073c4:	dffbfb93          	andi	s7,s7,-513
800073c8:	d202                	sw	zero,36(sp)
800073ca:	8ade                	mv	s5,s7
800073cc:	a841                	j	8000745c <__SEGGER_RTL_vfprintf+0x326>
800073ce:	d456                	sw	s5,40(sp)
800073d0:	4c01                	li	s8,0
800073d2:	0004ac83          	lw	s9,0(s1)
800073d6:	0491                	addi	s1,s1,4
800073d8:	018b9593          	slli	a1,s7,0x18
800073dc:	85fd                	srai	a1,a1,0x1f
800073de:	0235f413          	andi	s0,a1,35
800073e2:	100bea93          	ori	s5,s7,256
800073e6:	4b21                	li	s6,8
800073e8:	ac39                	j	80007606 <__SEGGER_RTL_vfprintf+0x4d0>
800073ea:	8b26                	mv	s6,s1
800073ec:	0004c483          	lbu	s1,0(s1)
800073f0:	0b11                	addi	s6,s6,4
800073f2:	1afd                	addi	s5,s5,-1
800073f4:	8552                	mv	a0,s4
800073f6:	85de                	mv	a1,s7
800073f8:	8656                	mv	a2,s5
800073fa:	39a1                	jal	80007052 <__SEGGER_RTL_pre_padding>
800073fc:	8552                	mv	a0,s4
800073fe:	85a6                	mv	a1,s1
80007400:	3eb1                	jal	80006f5c <__SEGGER_RTL_putc>
80007402:	84da                	mv	s1,s6
80007404:	a641                	j	80007784 <__SEGGER_RTL_vfprintf+0x64e>
80007406:	4088                	lw	a0,0(s1)
80007408:	008bf593          	andi	a1,s7,8
8000740c:	52059b63          	bnez	a1,80007942 <__SEGGER_RTL_vfprintf+0x80c>
80007410:	000a2583          	lw	a1,0(s4)
80007414:	002bf413          	andi	s0,s7,2
80007418:	58041263          	bnez	s0,8000799c <__SEGGER_RTL_vfprintf+0x866>
8000741c:	c10c                	sw	a1,0(a0)
8000741e:	a351                	j	800079a2 <__SEGGER_RTL_vfprintf+0x86c>
80007420:	4088                	lw	a0,0(s1)
80007422:	0491                	addi	s1,s1,4
80007424:	ae09                	j	80007736 <__SEGGER_RTL_vfprintf+0x600>
80007426:	d456                	sw	s5,40(sp)
80007428:	100bf593          	andi	a1,s7,256
8000742c:	8ade                	mv	s5,s7
8000742e:	c199                	beqz	a1,80007434 <__SEGGER_RTL_vfprintf+0x2fe>
80007430:	dffbfa93          	andi	s5,s7,-513
80007434:	0be2                	slli	s7,s7,0x18
80007436:	405bd593          	srai	a1,s7,0x5
8000743a:	81f9                	srli	a1,a1,0x1e
8000743c:	0592                	slli	a1,a1,0x4
8000743e:	a831                	j	8000745a <__SEGGER_RTL_vfprintf+0x324>
80007440:	658d                	lui	a1,0x3
80007442:	07858593          	addi	a1,a1,120 # 3078 <__BOOT_HEADER_segment_size__+0x1078>
80007446:	100bf613          	andi	a2,s7,256
8000744a:	8ade                	mv	s5,s7
8000744c:	c219                	beqz	a2,80007452 <__SEGGER_RTL_vfprintf+0x31c>
8000744e:	dffbfa93          	andi	s5,s7,-513
80007452:	0be2                	slli	s7,s7,0x18
80007454:	41fbd613          	srai	a2,s7,0x1f
80007458:	8df1                	and	a1,a1,a2
8000745a:	d22e                	sw	a1,36(sp)
8000745c:	002af613          	andi	a2,s5,2
80007460:	011a9693          	slli	a3,s5,0x11
80007464:	004af593          	andi	a1,s5,4
80007468:	0006c663          	bltz	a3,80007474 <__SEGGER_RTL_vfprintf+0x33e>
8000746c:	e20d                	bnez	a2,8000748e <__SEGGER_RTL_vfprintf+0x358>
8000746e:	00448693          	addi	a3,s1,4
80007472:	a02d                	j	8000749c <__SEGGER_RTL_vfprintf+0x366>
80007474:	e229                	bnez	a2,800074b6 <__SEGGER_RTL_vfprintf+0x380>
80007476:	0004ac83          	lw	s9,0(s1)
8000747a:	00448693          	addi	a3,s1,4
8000747e:	41fcdc13          	srai	s8,s9,0x1f
80007482:	c5a1                	beqz	a1,800074ca <__SEGGER_RTL_vfprintf+0x394>
80007484:	010c9593          	slli	a1,s9,0x10
80007488:	4105dc93          	srai	s9,a1,0x10
8000748c:	a0b1                	j	800074d8 <__SEGGER_RTL_vfprintf+0x3a2>
8000748e:	00748613          	addi	a2,s1,7
80007492:	ff867493          	andi	s1,a2,-8
80007496:	40d0                	lw	a2,4(s1)
80007498:	00848693          	addi	a3,s1,8
8000749c:	0004ac83          	lw	s9,0(s1)
800074a0:	e9a9                	bnez	a1,800074f2 <__SEGGER_RTL_vfprintf+0x3bc>
800074a2:	008af593          	andi	a1,s5,8
800074a6:	c199                	beqz	a1,800074ac <__SEGGER_RTL_vfprintf+0x376>
800074a8:	0ffcfc93          	zext.b	s9,s9
800074ac:	818d                	srli	a1,a1,0x3
800074ae:	15fd                	addi	a1,a1,-1
800074b0:	00c5fc33          	and	s8,a1,a2
800074b4:	a095                	j	80007518 <__SEGGER_RTL_vfprintf+0x3e2>
800074b6:	00748613          	addi	a2,s1,7
800074ba:	9a61                	andi	a2,a2,-8
800074bc:	00062c83          	lw	s9,0(a2)
800074c0:	00462c03          	lw	s8,4(a2)
800074c4:	00860693          	addi	a3,a2,8
800074c8:	fdd5                	bnez	a1,80007484 <__SEGGER_RTL_vfprintf+0x34e>
800074ca:	008af593          	andi	a1,s5,8
800074ce:	c599                	beqz	a1,800074dc <__SEGGER_RTL_vfprintf+0x3a6>
800074d0:	018c9593          	slli	a1,s9,0x18
800074d4:	4185dc93          	srai	s9,a1,0x18
800074d8:	41f5dc13          	srai	s8,a1,0x1f
800074dc:	020c4063          	bltz	s8,800074fc <__SEGGER_RTL_vfprintf+0x3c6>
800074e0:	020af593          	andi	a1,s5,32
800074e4:	e59d                	bnez	a1,80007512 <__SEGGER_RTL_vfprintf+0x3dc>
800074e6:	040af593          	andi	a1,s5,64
800074ea:	c59d                	beqz	a1,80007518 <__SEGGER_RTL_vfprintf+0x3e2>
800074ec:	02000593          	li	a1,32
800074f0:	a01d                	j	80007516 <__SEGGER_RTL_vfprintf+0x3e0>
800074f2:	4c01                	li	s8,0
800074f4:	0cc2                	slli	s9,s9,0x10
800074f6:	010cdc93          	srli	s9,s9,0x10
800074fa:	a839                	j	80007518 <__SEGGER_RTL_vfprintf+0x3e2>
800074fc:	019035b3          	snez	a1,s9
80007500:	41900cb3          	neg	s9,s9
80007504:	41800633          	neg	a2,s8
80007508:	40b60c33          	sub	s8,a2,a1
8000750c:	02d00593          	li	a1,45
80007510:	a019                	j	80007516 <__SEGGER_RTL_vfprintf+0x3e0>
80007512:	02b00593          	li	a1,43
80007516:	d22e                	sw	a1,36(sp)
80007518:	100af593          	andi	a1,s5,256
8000751c:	c199                	beqz	a1,80007522 <__SEGGER_RTL_vfprintf+0x3ec>
8000751e:	dffafa93          	andi	s5,s5,-513
80007522:	100af593          	andi	a1,s5,256
80007526:	e191                	bnez	a1,8000752a <__SEGGER_RTL_vfprintf+0x3f4>
80007528:	4b05                	li	s6,1
8000752a:	f9c50593          	addi	a1,a0,-100 # 1f9c <__NONCACHEABLE_RAM_segment_used_size__+0xedc>
8000752e:	4651                	li	a2,20
80007530:	0cb66563          	bltu	a2,a1,800075fa <__SEGGER_RTL_vfprintf+0x4c4>
80007534:	4672                	lw	a2,28(sp)
80007536:	00b65633          	srl	a2,a2,a1
8000753a:	8a05                	andi	a2,a2,1
8000753c:	ea31                	bnez	a2,80007590 <__SEGGER_RTL_vfprintf+0x45a>
8000753e:	00101637          	lui	a2,0x101
80007542:	00b65633          	srl	a2,a2,a1
80007546:	8a05                	andi	a2,a2,1
80007548:	ee4d                	bnez	a2,80007602 <__SEGGER_RTL_vfprintf+0x4cc>
8000754a:	462d                	li	a2,11
8000754c:	0ac59763          	bne	a1,a2,800075fa <__SEGGER_RTL_vfprintf+0x4c4>
80007550:	8736                	mv	a4,a3
80007552:	4b81                	li	s7,0
80007554:	018ce533          	or	a0,s9,s8
80007558:	c915                	beqz	a0,8000758c <__SEGGER_RTL_vfprintf+0x456>
8000755a:	003cd513          	srli	a0,s9,0x3
8000755e:	01dc1593          	slli	a1,s8,0x1d
80007562:	8dc9                	or	a1,a1,a0
80007564:	04610513          	addi	a0,sp,70
80007568:	007cf613          	andi	a2,s9,7
8000756c:	8cae                	mv	s9,a1
8000756e:	0b85                	addi	s7,s7,1
80007570:	003c5c13          	srli	s8,s8,0x3
80007574:	818d                	srli	a1,a1,0x3
80007576:	03060613          	addi	a2,a2,48 # 101030 <_flash_size+0x1030>
8000757a:	018ce6b3          	or	a3,s9,s8
8000757e:	00c50023          	sb	a2,0(a0)
80007582:	01dc1613          	slli	a2,s8,0x1d
80007586:	8dd1                	or	a1,a1,a2
80007588:	0505                	addi	a0,a0,1
8000758a:	fef9                	bnez	a3,80007568 <__SEGGER_RTL_vfprintf+0x432>
8000758c:	d63a                	sw	a4,44(sp)
8000758e:	acbd                	j	8000780c <__SEGGER_RTL_vfprintf+0x6d6>
80007590:	d636                	sw	a3,44(sp)
80007592:	4b81                	li	s7,0
80007594:	018ce533          	or	a0,s9,s8
80007598:	26050a63          	beqz	a0,8000780c <__SEGGER_RTL_vfprintf+0x6d6>
8000759c:	6521                	lui	a0,0x8
8000759e:	00aaf4b3          	and	s1,s5,a0
800075a2:	c085                	beqz	s1,800075c2 <__SEGGER_RTL_vfprintf+0x48c>
800075a4:	003bf513          	andi	a0,s7,3
800075a8:	458d                	li	a1,3
800075aa:	00b51c63          	bne	a0,a1,800075c2 <__SEGGER_RTL_vfprintf+0x48c>
800075ae:	04610413          	addi	s0,sp,70
800075b2:	01740533          	add	a0,s0,s7
800075b6:	02c00593          	li	a1,44
800075ba:	00b50023          	sb	a1,0(a0) # 8000 <__AHB_SRAM_segment_size__>
800075be:	0b85                	addi	s7,s7,1
800075c0:	a019                	j	800075c6 <__SEGGER_RTL_vfprintf+0x490>
800075c2:	04610413          	addi	s0,sp,70
800075c6:	4629                	li	a2,10
800075c8:	8566                	mv	a0,s9
800075ca:	85e2                	mv	a1,s8
800075cc:	4681                	li	a3,0
800075ce:	711020ef          	jal	8000a4de <__udivdi3>
800075d2:	001c3613          	seqz	a2,s8
800075d6:	033506b3          	mul	a3,a0,s3
800075da:	01740733          	add	a4,s0,s7
800075de:	40dc86b3          	sub	a3,s9,a3
800075e2:	00acb793          	sltiu	a5,s9,10
800075e6:	8e7d                	and	a2,a2,a5
800075e8:	0306e693          	ori	a3,a3,48
800075ec:	00d70023          	sb	a3,0(a4)
800075f0:	0b85                	addi	s7,s7,1
800075f2:	8caa                	mv	s9,a0
800075f4:	8c2e                	mv	s8,a1
800075f6:	d655                	beqz	a2,800075a2 <__SEGGER_RTL_vfprintf+0x46c>
800075f8:	ac11                	j	8000780c <__SEGGER_RTL_vfprintf+0x6d6>
800075fa:	05800593          	li	a1,88
800075fe:	20b51563          	bne	a0,a1,80007808 <__SEGGER_RTL_vfprintf+0x6d2>
80007602:	84b6                	mv	s1,a3
80007604:	5412                	lw	s0,36(sp)
80007606:	018ce533          	or	a0,s9,s8
8000760a:	d626                	sw	s1,44(sp)
8000760c:	c929                	beqz	a0,8000765e <__SEGGER_RTL_vfprintf+0x528>
8000760e:	012a9593          	slli	a1,s5,0x12
80007612:	8000b537          	lui	a0,0x8000b
80007616:	28050513          	addi	a0,a0,640 # 8000b280 <__SEGGER_RTL_hex_lc>
8000761a:	0005d663          	bgez	a1,80007626 <__SEGGER_RTL_vfprintf+0x4f0>
8000761e:	8000b537          	lui	a0,0x8000b
80007622:	27050513          	addi	a0,a0,624 # 8000b270 <__SEGGER_RTL_hex_uc>
80007626:	4b81                	li	s7,0
80007628:	004cd593          	srli	a1,s9,0x4
8000762c:	01cc1613          	slli	a2,s8,0x1c
80007630:	8e4d                	or	a2,a2,a1
80007632:	04610593          	addi	a1,sp,70
80007636:	00fcf693          	andi	a3,s9,15
8000763a:	8cb2                	mv	s9,a2
8000763c:	004c5c13          	srli	s8,s8,0x4
80007640:	8211                	srli	a2,a2,0x4
80007642:	96aa                	add	a3,a3,a0
80007644:	018ce733          	or	a4,s9,s8
80007648:	0006c683          	lbu	a3,0(a3)
8000764c:	01cc1793          	slli	a5,s8,0x1c
80007650:	8e5d                	or	a2,a2,a5
80007652:	0b85                	addi	s7,s7,1
80007654:	00d58023          	sb	a3,0(a1)
80007658:	0585                	addi	a1,a1,1
8000765a:	ff71                	bnez	a4,80007636 <__SEGGER_RTL_vfprintf+0x500>
8000765c:	aa4d                	j	8000780e <__SEGGER_RTL_vfprintf+0x6d8>
8000765e:	4b81                	li	s7,0
80007660:	a27d                	j	8000780e <__SEGGER_RTL_vfprintf+0x6d8>
80007662:	6509                	lui	a0,0x2
80007664:	00abebb3          	or	s7,s7,a0
80007668:	5502                	lw	a0,32(sp)
8000766a:	00abecb3          	or	s9,s7,a0
8000766e:	002cf513          	andi	a0,s9,2
80007672:	ed01                	bnez	a0,8000768a <__SEGGER_RTL_vfprintf+0x554>
80007674:	00748513          	addi	a0,s1,7
80007678:	ff857613          	andi	a2,a0,-8
8000767c:	4208                	lw	a0,0(a2)
8000767e:	424c                	lw	a1,4(a2)
80007680:	00860493          	addi	s1,a2,8
80007684:	e12ff0ef          	jal	80006c96 <__truncdfsf2>
80007688:	a831                	j	800076a4 <__SEGGER_RTL_vfprintf+0x56e>
8000768a:	4088                	lw	a0,0(s1)
8000768c:	410c                	lw	a1,0(a0)
8000768e:	4150                	lw	a2,4(a0)
80007690:	4514                	lw	a3,8(a0)
80007692:	4558                	lw	a4,12(a0)
80007694:	0491                	addi	s1,s1,4
80007696:	1808                	addi	a0,sp,48
80007698:	d82e                	sw	a1,48(sp)
8000769a:	da32                	sw	a2,52(sp)
8000769c:	dc36                	sw	a3,56(sp)
8000769e:	de3a                	sw	a4,60(sp)
800076a0:	3f5020ef          	jal	8000a294 <__trunctfsf2>
800076a4:	842a                	mv	s0,a0
800076a6:	100cf513          	andi	a0,s9,256
800076aa:	e111                	bnez	a0,800076ae <__SEGGER_RTL_vfprintf+0x578>
800076ac:	4b19                	li	s6,6
800076ae:	000b1863          	bnez	s6,800076be <__SEGGER_RTL_vfprintf+0x588>
800076b2:	5582                	lw	a1,32(sp)
800076b4:	00bcf533          	and	a0,s9,a1
800076b8:	8d2d                	xor	a0,a0,a1
800076ba:	00153b13          	seqz	s6,a0
800076be:	8522                	mv	a0,s0
800076c0:	3fb020ef          	jal	8000a2ba <__SEGGER_RTL_float32_isinf>
800076c4:	c505                	beqz	a0,800076ec <__SEGGER_RTL_vfprintf+0x5b6>
800076c6:	8522                	mv	a0,s0
800076c8:	4581                	li	a1,0
800076ca:	b0aff0ef          	jal	800069d4 <__ltsf2>
800076ce:	6589                	lui	a1,0x2
800076d0:	00bcf5b3          	and	a1,s9,a1
800076d4:	02055d63          	bgez	a0,8000770e <__SEGGER_RTL_vfprintf+0x5d8>
800076d8:	8000b537          	lui	a0,0x8000b
800076dc:	05e50513          	addi	a0,a0,94 # 8000b05e <.L.str.2>
800076e0:	c5b9                	beqz	a1,8000772e <__SEGGER_RTL_vfprintf+0x5f8>
800076e2:	8000b537          	lui	a0,0x8000b
800076e6:	05950513          	addi	a0,a0,89 # 8000b059 <.L.str.1>
800076ea:	a091                	j	8000772e <__SEGGER_RTL_vfprintf+0x5f8>
800076ec:	8522                	mv	a0,s0
800076ee:	3c1020ef          	jal	8000a2ae <__SEGGER_RTL_float32_isnan>
800076f2:	c15d                	beqz	a0,80007798 <__SEGGER_RTL_vfprintf+0x662>
800076f4:	012c9593          	slli	a1,s9,0x12
800076f8:	8000b537          	lui	a0,0x8000b
800076fc:	29450513          	addi	a0,a0,660 # 8000b294 <.L.str.6>
80007700:	0205d763          	bgez	a1,8000772e <__SEGGER_RTL_vfprintf+0x5f8>
80007704:	8000b537          	lui	a0,0x8000b
80007708:	29050513          	addi	a0,a0,656 # 8000b290 <.L.str.5>
8000770c:	a00d                	j	8000772e <__SEGGER_RTL_vfprintf+0x5f8>
8000770e:	c591                	beqz	a1,8000771a <__SEGGER_RTL_vfprintf+0x5e4>
80007710:	8000b5b7          	lui	a1,0x8000b
80007714:	06358593          	addi	a1,a1,99 # 8000b063 <.L.str.3>
80007718:	a029                	j	80007722 <__SEGGER_RTL_vfprintf+0x5ec>
8000771a:	8000b5b7          	lui	a1,0x8000b
8000771e:	06858593          	addi	a1,a1,104 # 8000b068 <.L.str.4>
80007722:	00158513          	addi	a0,a1,1
80007726:	020cf613          	andi	a2,s9,32
8000772a:	c211                	beqz	a2,8000772e <__SEGGER_RTL_vfprintf+0x5f8>
8000772c:	852e                	mv	a0,a1
8000772e:	effcfb93          	andi	s7,s9,-257
80007732:	02500c93          	li	s9,37
80007736:	29918413          	addi	s0,gp,665 # 800043cd <.L.str>
8000773a:	c111                	beqz	a0,8000773e <__SEGGER_RTL_vfprintf+0x608>
8000773c:	842a                	mv	s0,a0
8000773e:	100bf513          	andi	a0,s7,256
80007742:	e509                	bnez	a0,8000774c <__SEGGER_RTL_vfprintf+0x616>
80007744:	8522                	mv	a0,s0
80007746:	6ec030ef          	jal	8000ae32 <strlen>
8000774a:	a029                	j	80007754 <__SEGGER_RTL_vfprintf+0x61e>
8000774c:	8522                	mv	a0,s0
8000774e:	85da                	mv	a1,s6
80007750:	f6eff0ef          	jal	80006ebe <strnlen>
80007754:	8b2a                	mv	s6,a0
80007756:	dffbfb93          	andi	s7,s7,-513
8000775a:	40aa8ab3          	sub	s5,s5,a0
8000775e:	8552                	mv	a0,s4
80007760:	85de                	mv	a1,s7
80007762:	8656                	mv	a2,s5
80007764:	30fd                	jal	80007052 <__SEGGER_RTL_pre_padding>
80007766:	000b0f63          	beqz	s6,80007784 <__SEGGER_RTL_vfprintf+0x64e>
8000776a:	8c26                	mv	s8,s1
8000776c:	9b22                	add	s6,s6,s0
8000776e:	00044583          	lbu	a1,0(s0)
80007772:	00140493          	addi	s1,s0,1
80007776:	8552                	mv	a0,s4
80007778:	fe4ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
8000777c:	8426                	mv	s0,s1
8000777e:	ff6498e3          	bne	s1,s6,8000776e <__SEGGER_RTL_vfprintf+0x638>
80007782:	84e2                	mv	s1,s8
80007784:	010bf413          	andi	s0,s7,16
80007788:	a00408e3          	beqz	s0,80007198 <__SEGGER_RTL_vfprintf+0x62>
8000778c:	02000593          	li	a1,32
80007790:	8552                	mv	a0,s4
80007792:	8656                	mv	a2,s5
80007794:	3069                	jal	8000701e <__SEGGER_RTL_print_padding>
80007796:	b409                	j	80007198 <__SEGGER_RTL_vfprintf+0x62>
80007798:	d456                	sw	s5,40(sp)
8000779a:	8522                	mv	a0,s0
8000779c:	32f020ef          	jal	8000a2ca <__SEGGER_RTL_float32_isnormal>
800077a0:	00153513          	seqz	a0,a0
800077a4:	157d                	addi	a0,a0,-1
800077a6:	00857bb3          	and	s7,a0,s0
800077aa:	855e                	mv	a0,s7
800077ac:	337020ef          	jal	8000a2e2 <__SEGGER_RTL_float32_signbit>
800077b0:	8aaa                	mv	s5,a0
800077b2:	00a03533          	snez	a0,a0
800077b6:	057e                	slli	a0,a0,0x1f
800077b8:	00abc433          	xor	s0,s7,a0
800077bc:	08ec                	addi	a1,sp,92
800077be:	8522                	mv	a0,s0
800077c0:	d5cff0ef          	jal	80006d1c <frexpf>
800077c4:	4576                	lw	a0,92(sp)
800077c6:	00151593          	slli	a1,a0,0x1
800077ca:	952e                	add	a0,a0,a1
800077cc:	45e2                	lw	a1,24(sp)
800077ce:	02b51533          	mulh	a0,a0,a1
800077d2:	01f55c13          	srli	s8,a0,0x1f
800077d6:	8509                	srai	a0,a0,0x2
800077d8:	9c2a                	add	s8,s8,a0
800077da:	cee2                	sw	s8,92(sp)
800077dc:	855e                	mv	a0,s7
800077de:	4581                	li	a1,0
800077e0:	1c1020ef          	jal	8000a1a0 <__eqsf2>
800077e4:	0e050963          	beqz	a0,800078d6 <__SEGGER_RTL_vfprintf+0x7a0>
800077e8:	001c0513          	addi	a0,s8,1
800077ec:	6ae030ef          	jal	8000ae9a <__SEGGER_RTL_pow10f>
800077f0:	85aa                	mv	a1,a0
800077f2:	8522                	mv	a0,s0
800077f4:	a50ff0ef          	jal	80006a44 <__gtsf2>
800077f8:	0ca05263          	blez	a0,800078bc <__SEGGER_RTL_vfprintf+0x786>
800077fc:	4576                	lw	a0,92(sp)
800077fe:	00150593          	addi	a1,a0,1
80007802:	ceae                	sw	a1,92(sp)
80007804:	0509                	addi	a0,a0,2
80007806:	b7dd                	j	800077ec <__SEGGER_RTL_vfprintf+0x6b6>
80007808:	4b81                	li	s7,0
8000780a:	d636                	sw	a3,44(sp)
8000780c:	5412                	lw	s0,36(sp)
8000780e:	417b0533          	sub	a0,s6,s7
80007812:	10043593          	sltiu	a1,s0,256
80007816:	8ca2                	mv	s9,s0
80007818:	00143613          	seqz	a2,s0
8000781c:	15f9                	addi	a1,a1,-2
8000781e:	167d                	addi	a2,a2,-1
80007820:	8df1                	and	a1,a1,a2
80007822:	00a02633          	sgtz	a2,a0
80007826:	40c004b3          	neg	s1,a2
8000782a:	8ce9                	and	s1,s1,a0
8000782c:	009b8533          	add	a0,s7,s1
80007830:	5422                	lw	s0,40(sp)
80007832:	8c09                	sub	s0,s0,a0
80007834:	200af513          	andi	a0,s5,512
80007838:	00b40b33          	add	s6,s0,a1
8000783c:	4c05                	li	s8,1
8000783e:	e511                	bnez	a0,8000784a <__SEGGER_RTL_vfprintf+0x714>
80007840:	8552                	mv	a0,s4
80007842:	85d6                	mv	a1,s5
80007844:	865a                	mv	a2,s6
80007846:	3031                	jal	80007052 <__SEGGER_RTL_pre_padding>
80007848:	4b01                	li	s6,0
8000784a:	04510413          	addi	s0,sp,69
8000784e:	10000513          	li	a0,256
80007852:	00ace963          	bltu	s9,a0,80007864 <__SEGGER_RTL_vfprintf+0x72e>
80007856:	008cd593          	srli	a1,s9,0x8
8000785a:	8552                	mv	a0,s4
8000785c:	f00ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007860:	85e6                	mv	a1,s9
80007862:	a021                	j	8000786a <__SEGGER_RTL_vfprintf+0x734>
80007864:	85e6                	mv	a1,s9
80007866:	000c8563          	beqz	s9,80007870 <__SEGGER_RTL_vfprintf+0x73a>
8000786a:	8552                	mv	a0,s4
8000786c:	ef0ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007870:	8552                	mv	a0,s4
80007872:	85d6                	mv	a1,s5
80007874:	865a                	mv	a2,s6
80007876:	fdcff0ef          	jal	80007052 <__SEGGER_RTL_pre_padding>
8000787a:	03000593          	li	a1,48
8000787e:	8552                	mv	a0,s4
80007880:	8626                	mv	a2,s1
80007882:	f9cff0ef          	jal	8000701e <__SEGGER_RTL_print_padding>
80007886:	01705d63          	blez	s7,800078a0 <__SEGGER_RTL_vfprintf+0x76a>
8000788a:	84de                	mv	s1,s7
8000788c:	01740533          	add	a0,s0,s7
80007890:	00054583          	lbu	a1,0(a0)
80007894:	1bfd                	addi	s7,s7,-1
80007896:	8552                	mv	a0,s4
80007898:	ec4ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
8000789c:	fe9c67e3          	bltu	s8,s1,8000788a <__SEGGER_RTL_vfprintf+0x754>
800078a0:	010af513          	andi	a0,s5,16
800078a4:	54b2                	lw	s1,44(sp)
800078a6:	02500c93          	li	s9,37
800078aa:	8e0507e3          	beqz	a0,80007198 <__SEGGER_RTL_vfprintf+0x62>
800078ae:	02000593          	li	a1,32
800078b2:	8552                	mv	a0,s4
800078b4:	865a                	mv	a2,s6
800078b6:	f68ff0ef          	jal	8000701e <__SEGGER_RTL_print_padding>
800078ba:	b8f9                	j	80007198 <__SEGGER_RTL_vfprintf+0x62>
800078bc:	4576                	lw	a0,92(sp)
800078be:	5dc030ef          	jal	8000ae9a <__SEGGER_RTL_pow10f>
800078c2:	85aa                	mv	a1,a0
800078c4:	8522                	mv	a0,s0
800078c6:	90eff0ef          	jal	800069d4 <__ltsf2>
800078ca:	00055663          	bgez	a0,800078d6 <__SEGGER_RTL_vfprintf+0x7a0>
800078ce:	4576                	lw	a0,92(sp)
800078d0:	157d                	addi	a0,a0,-1
800078d2:	ceaa                	sw	a0,92(sp)
800078d4:	b7ed                	j	800078be <__SEGGER_RTL_vfprintf+0x788>
800078d6:	001ab513          	seqz	a0,s5
800078da:	157d                	addi	a0,a0,-1
800078dc:	06057593          	andi	a1,a0,96
800078e0:	4576                	lw	a0,92(sp)
800078e2:	00bcec33          	or	s8,s9,a1
800078e6:	5582                	lw	a1,32(sp)
800078e8:	00bc7ab3          	and	s5,s8,a1
800078ec:	40000593          	li	a1,1024
800078f0:	d626                	sw	s1,44(sp)
800078f2:	02ba8a63          	beq	s5,a1,80007926 <__SEGGER_RTL_vfprintf+0x7f0>
800078f6:	5582                	lw	a1,32(sp)
800078f8:	00ba9763          	bne	s5,a1,80007906 <__SEGGER_RTL_vfprintf+0x7d0>
800078fc:	03655563          	bge	a0,s6,80007926 <__SEGGER_RTL_vfprintf+0x7f0>
80007900:	55ed                	li	a1,-5
80007902:	02a5d263          	bge	a1,a0,80007926 <__SEGGER_RTL_vfprintf+0x7f0>
80007906:	400c7593          	andi	a1,s8,1024
8000790a:	080c7693          	andi	a3,s8,128
8000790e:	ca36                	sw	a3,20(sp)
80007910:	80003ab7          	lui	s5,0x80003
80007914:	068a8a93          	addi	s5,s5,104 # 80003068 <__SEGGER_RTL_ipow10>
80007918:	0c058b63          	beqz	a1,800079ee <__SEGGER_RTL_vfprintf+0x8b8>
8000791c:	45b9                	li	a1,14
8000791e:	08a5d563          	bge	a1,a0,800079a8 <__SEGGER_RTL_vfprintf+0x872>
80007922:	4b01                	li	s6,0
80007924:	a0e9                	j	800079ee <__SEGGER_RTL_vfprintf+0x8b8>
80007926:	02500c93          	li	s9,37
8000792a:	02600593          	li	a1,38
8000792e:	00b51f63          	bne	a0,a1,8000794c <__SEGGER_RTL_vfprintf+0x816>
80007932:	8522                	mv	a0,s0
80007934:	45b2                	lw	a1,12(sp)
80007936:	76a020ef          	jal	8000a0a0 <__divsf3>
8000793a:	a00d                	j	8000795c <__SEGGER_RTL_vfprintf+0x826>
8000793c:	84051ee3          	bnez	a0,80007198 <__SEGGER_RTL_vfprintf+0x62>
80007940:	a509                	j	80007f42 <__SEGGER_RTL_vfprintf+0xe0c>
80007942:	000a2583          	lw	a1,0(s4)
80007946:	00b50023          	sb	a1,0(a0)
8000794a:	a8a1                	j	800079a2 <__SEGGER_RTL_vfprintf+0x86c>
8000794c:	40a00533          	neg	a0,a0
80007950:	54a030ef          	jal	8000ae9a <__SEGGER_RTL_pow10f>
80007954:	85aa                	mv	a1,a0
80007956:	8522                	mv	a0,s0
80007958:	698020ef          	jal	80009ff0 <__mulsf3>
8000795c:	842a                	mv	s0,a0
8000795e:	4581                	li	a1,0
80007960:	041020ef          	jal	8000a1a0 <__eqsf2>
80007964:	1a050c63          	beqz	a0,80007b1c <__SEGGER_RTL_vfprintf+0x9e6>
80007968:	8522                	mv	a0,s0
8000796a:	151020ef          	jal	8000a2ba <__SEGGER_RTL_float32_isinf>
8000796e:	14050c63          	beqz	a0,80007ac6 <__SEGGER_RTL_vfprintf+0x990>
80007972:	8522                	mv	a0,s0
80007974:	4581                	li	a1,0
80007976:	85eff0ef          	jal	800069d4 <__ltsf2>
8000797a:	6589                	lui	a1,0x2
8000797c:	00bc75b3          	and	a1,s8,a1
80007980:	54055d63          	bgez	a0,80007eda <__SEGGER_RTL_vfprintf+0xda4>
80007984:	8000b537          	lui	a0,0x8000b
80007988:	05e50513          	addi	a0,a0,94 # 8000b05e <.L.str.2>
8000798c:	5aa2                	lw	s5,40(sp)
8000798e:	56058763          	beqz	a1,80007efc <__SEGGER_RTL_vfprintf+0xdc6>
80007992:	8000b537          	lui	a0,0x8000b
80007996:	05950513          	addi	a0,a0,89 # 8000b059 <.L.str.1>
8000799a:	a38d                	j	80007efc <__SEGGER_RTL_vfprintf+0xdc6>
8000799c:	c10c                	sw	a1,0(a0)
8000799e:	00052223          	sw	zero,4(a0)
800079a2:	0491                	addi	s1,s1,4
800079a4:	ff4ff06f          	j	80007198 <__SEGGER_RTL_vfprintf+0x62>
800079a8:	fff54593          	not	a1,a0
800079ac:	95da                	add	a1,a1,s6
800079ae:	4641                	li	a2,16
800079b0:	8b2e                	mv	s6,a1
800079b2:	00c5c363          	blt	a1,a2,800079b8 <__SEGGER_RTL_vfprintf+0x882>
800079b6:	4b41                	li	s6,16
800079b8:	ea9d                	bnez	a3,800079ee <__SEGGER_RTL_vfprintf+0x8b8>
800079ba:	c995                	beqz	a1,800079ee <__SEGGER_RTL_vfprintf+0x8b8>
800079bc:	855a                	mv	a0,s6
800079be:	4dc030ef          	jal	8000ae9a <__SEGGER_RTL_pow10f>
800079c2:	85aa                	mv	a1,a0
800079c4:	8522                	mv	a0,s0
800079c6:	62a020ef          	jal	80009ff0 <__mulsf3>
800079ca:	3f0005b7          	lui	a1,0x3f000
800079ce:	e59fe0ef          	jal	80006826 <__addsf3>
800079d2:	2a5020ef          	jal	8000a476 <floorf>
800079d6:	412005b7          	lui	a1,0x41200
800079da:	151020ef          	jal	8000a32a <fmodf>
800079de:	4581                	li	a1,0
800079e0:	7c0020ef          	jal	8000a1a0 <__eqsf2>
800079e4:	e501                	bnez	a0,800079ec <__SEGGER_RTL_vfprintf+0x8b6>
800079e6:	1b7d                	addi	s6,s6,-1
800079e8:	fc0b1ae3          	bnez	s6,800079bc <__SEGGER_RTL_vfprintf+0x886>
800079ec:	4576                	lw	a0,92(sp)
800079ee:	416005b3          	neg	a1,s6
800079f2:	1541                	addi	a0,a0,-16
800079f4:	00a5c363          	blt	a1,a0,800079fa <__SEGGER_RTL_vfprintf+0x8c4>
800079f8:	852e                	mv	a0,a1
800079fa:	4a0030ef          	jal	8000ae9a <__SEGGER_RTL_pow10f>
800079fe:	55fd                	li	a1,-1
80007a00:	0e7020ef          	jal	8000a2e6 <ldexpf>
80007a04:	85aa                	mv	a1,a0
80007a06:	8522                	mv	a0,s0
80007a08:	e1ffe0ef          	jal	80006826 <__addsf3>
80007a0c:	8baa                	mv	s7,a0
80007a0e:	4576                	lw	a0,92(sp)
80007a10:	0505                	addi	a0,a0,1
80007a12:	488030ef          	jal	8000ae9a <__SEGGER_RTL_pow10f>
80007a16:	85aa                	mv	a1,a0
80007a18:	855e                	mv	a0,s7
80007a1a:	85cff0ef          	jal	80006a76 <__gesf2>
80007a1e:	45f6                	lw	a1,92(sp)
80007a20:	00052513          	slti	a0,a0,0
80007a24:	00154513          	xori	a0,a0,1
80007a28:	952e                	add	a0,a0,a1
80007a2a:	02054663          	bltz	a0,80007a56 <__SEGGER_RTL_vfprintf+0x920>
80007a2e:	45c5                	li	a1,17
80007a30:	02b56863          	bltu	a0,a1,80007a60 <__SEGGER_RTL_vfprintf+0x92a>
80007a34:	ff050593          	addi	a1,a0,-16
80007a38:	ceae                	sw	a1,92(sp)
80007a3a:	40ad8533          	sub	a0,s11,a0
80007a3e:	45c030ef          	jal	8000ae9a <__SEGGER_RTL_pow10f>
80007a42:	85aa                	mv	a1,a0
80007a44:	855e                	mv	a0,s7
80007a46:	5aa020ef          	jal	80009ff0 <__mulsf3>
80007a4a:	782020ef          	jal	8000a1cc <__fixunssfdi>
80007a4e:	842a                	mv	s0,a0
80007a50:	84ae                	mv	s1,a1
80007a52:	d202                	sw	zero,36(sp)
80007a54:	a01d                	j	80007a7a <__SEGGER_RTL_vfprintf+0x944>
80007a56:	d25e                	sw	s7,36(sp)
80007a58:	4401                	li	s0,0
80007a5a:	4481                	li	s1,0
80007a5c:	ce82                	sw	zero,92(sp)
80007a5e:	a831                	j	80007a7a <__SEGGER_RTL_vfprintf+0x944>
80007a60:	ce82                	sw	zero,92(sp)
80007a62:	855e                	mv	a0,s7
80007a64:	768020ef          	jal	8000a1cc <__fixunssfdi>
80007a68:	842a                	mv	s0,a0
80007a6a:	84ae                	mv	s1,a1
80007a6c:	980ff0ef          	jal	80006bec <__floatundisf>
80007a70:	85aa                	mv	a1,a0
80007a72:	855e                	mv	a0,s7
80007a74:	dabfe0ef          	jal	8000681e <__subsf3>
80007a78:	d22a                	sw	a0,36(sp)
80007a7a:	4c81                	li	s9,0
80007a7c:	bffc7b93          	andi	s7,s8,-1025
80007a80:	5522                	lw	a0,40(sp)
80007a82:	40ab0533          	sub	a0,s6,a0
80007a86:	008a8593          	addi	a1,s5,8
80007a8a:	46d2                	lw	a3,20(sp)
80007a8c:	41d0                	lw	a2,4(a1)
80007a8e:	00c48563          	beq	s1,a2,80007a98 <__SEGGER_RTL_vfprintf+0x962>
80007a92:	00c4b633          	sltu	a2,s1,a2
80007a96:	a021                	j	80007a9e <__SEGGER_RTL_vfprintf+0x968>
80007a98:	4190                	lw	a2,0(a1)
80007a9a:	00c43633          	sltu	a2,s0,a2
80007a9e:	0505                	addi	a0,a0,1
80007aa0:	0c85                	addi	s9,s9,1
80007aa2:	05a1                	addi	a1,a1,8 # 41200008 <__NONCACHEABLE_RAM_segment_end__+0x3ffc0008>
80007aa4:	d665                	beqz	a2,80007a8c <__SEGGER_RTL_vfprintf+0x956>
80007aa6:	45f6                	lw	a1,92(sp)
80007aa8:	00db6633          	or	a2,s6,a3
80007aac:	060c7693          	andi	a3,s8,96
80007ab0:	00163613          	seqz	a2,a2
80007ab4:	00d036b3          	snez	a3,a3
80007ab8:	fff6c693          	not	a3,a3
80007abc:	9636                	add	a2,a2,a3
80007abe:	8e0d                	sub	a2,a2,a1
80007ac0:	40a60ab3          	sub	s5,a2,a0
80007ac4:	a2e9                	j	80007c8e <__SEGGER_RTL_vfprintf+0xb58>
80007ac6:	44f6                	lw	s1,92(sp)
80007ac8:	412005b7          	lui	a1,0x41200
80007acc:	8522                	mv	a0,s0
80007ace:	fa9fe0ef          	jal	80006a76 <__gesf2>
80007ad2:	02054063          	bltz	a0,80007af2 <__SEGGER_RTL_vfprintf+0x9bc>
80007ad6:	412005b7          	lui	a1,0x41200
80007ada:	8522                	mv	a0,s0
80007adc:	5c4020ef          	jal	8000a0a0 <__divsf3>
80007ae0:	842a                	mv	s0,a0
80007ae2:	0485                	addi	s1,s1,1
80007ae4:	412005b7          	lui	a1,0x41200
80007ae8:	f8ffe0ef          	jal	80006a76 <__gesf2>
80007aec:	fe0555e3          	bgez	a0,80007ad6 <__SEGGER_RTL_vfprintf+0x9a0>
80007af0:	cea6                	sw	s1,92(sp)
80007af2:	3f8005b7          	lui	a1,0x3f800
80007af6:	8522                	mv	a0,s0
80007af8:	eddfe0ef          	jal	800069d4 <__ltsf2>
80007afc:	02055063          	bgez	a0,80007b1c <__SEGGER_RTL_vfprintf+0x9e6>
80007b00:	412005b7          	lui	a1,0x41200
80007b04:	8522                	mv	a0,s0
80007b06:	4ea020ef          	jal	80009ff0 <__mulsf3>
80007b0a:	842a                	mv	s0,a0
80007b0c:	14fd                	addi	s1,s1,-1
80007b0e:	3f8005b7          	lui	a1,0x3f800
80007b12:	ec3fe0ef          	jal	800069d4 <__ltsf2>
80007b16:	fe0545e3          	bltz	a0,80007b00 <__SEGGER_RTL_vfprintf+0x9ca>
80007b1a:	cea6                	sw	s1,92(sp)
80007b1c:	001b3513          	seqz	a0,s6
80007b20:	5582                	lw	a1,32(sp)
80007b22:	00bac5b3          	xor	a1,s5,a1
80007b26:	0015b593          	seqz	a1,a1
80007b2a:	40bb0b33          	sub	s6,s6,a1
80007b2e:	157d                	addi	a0,a0,-1
80007b30:	01657bb3          	and	s7,a0,s6
80007b34:	41700533          	neg	a0,s7
80007b38:	362030ef          	jal	8000ae9a <__SEGGER_RTL_pow10f>
80007b3c:	55fd                	li	a1,-1
80007b3e:	7a8020ef          	jal	8000a2e6 <ldexpf>
80007b42:	85aa                	mv	a1,a0
80007b44:	8522                	mv	a0,s0
80007b46:	ce1fe0ef          	jal	80006826 <__addsf3>
80007b4a:	8caa                	mv	s9,a0
80007b4c:	412005b7          	lui	a1,0x41200
80007b50:	f27fe0ef          	jal	80006a76 <__gesf2>
80007b54:	00054b63          	bltz	a0,80007b6a <__SEGGER_RTL_vfprintf+0xa34>
80007b58:	4576                	lw	a0,92(sp)
80007b5a:	0505                	addi	a0,a0,1
80007b5c:	ceaa                	sw	a0,92(sp)
80007b5e:	412005b7          	lui	a1,0x41200
80007b62:	8566                	mv	a0,s9
80007b64:	53c020ef          	jal	8000a0a0 <__divsf3>
80007b68:	8caa                	mv	s9,a0
80007b6a:	5aa2                	lw	s5,40(sp)
80007b6c:	060b8563          	beqz	s7,80007bd6 <__SEGGER_RTL_vfprintf+0xaa0>
80007b70:	5502                	lw	a0,32(sp)
80007b72:	c8050513          	addi	a0,a0,-896
80007b76:	00ac7533          	and	a0,s8,a0
80007b7a:	4592                	lw	a1,4(sp)
80007b7c:	04b51e63          	bne	a0,a1,80007bd8 <__SEGGER_RTL_vfprintf+0xaa2>
80007b80:	4541                	li	a0,16
80007b82:	00abc363          	blt	s7,a0,80007b88 <__SEGGER_RTL_vfprintf+0xa52>
80007b86:	4bc1                	li	s7,16
80007b88:	855e                	mv	a0,s7
80007b8a:	310030ef          	jal	8000ae9a <__SEGGER_RTL_pow10f>
80007b8e:	85aa                	mv	a1,a0
80007b90:	8566                	mv	a0,s9
80007b92:	45e020ef          	jal	80009ff0 <__mulsf3>
80007b96:	636020ef          	jal	8000a1cc <__fixunssfdi>
80007b9a:	842a                	mv	s0,a0
80007b9c:	8d4d                	or	a0,a0,a1
80007b9e:	cd05                	beqz	a0,80007bd6 <__SEGGER_RTL_vfprintf+0xaa0>
80007ba0:	84ae                	mv	s1,a1
80007ba2:	4629                	li	a2,10
80007ba4:	8522                	mv	a0,s0
80007ba6:	85a6                	mv	a1,s1
80007ba8:	4681                	li	a3,0
80007baa:	135020ef          	jal	8000a4de <__udivdi3>
80007bae:	03358633          	mul	a2,a1,s3
80007bb2:	033536b3          	mulhu	a3,a0,s3
80007bb6:	9636                	add	a2,a2,a3
80007bb8:	033506b3          	mul	a3,a0,s3
80007bbc:	8c91                	sub	s1,s1,a2
80007bbe:	00d43633          	sltu	a2,s0,a3
80007bc2:	8c91                	sub	s1,s1,a2
80007bc4:	8c15                	sub	s0,s0,a3
80007bc6:	8c45                	or	s0,s0,s1
80007bc8:	32041e63          	bnez	s0,80007f04 <__SEGGER_RTL_vfprintf+0xdce>
80007bcc:	1bfd                	addi	s7,s7,-1
80007bce:	842a                	mv	s0,a0
80007bd0:	84ae                	mv	s1,a1
80007bd2:	fc0b98e3          	bnez	s7,80007ba2 <__SEGGER_RTL_vfprintf+0xa6c>
80007bd6:	4b01                	li	s6,0
80007bd8:	d266                	sw	s9,36(sp)
80007bda:	080c7513          	andi	a0,s8,128
80007bde:	416a85b3          	sub	a1,s5,s6
80007be2:	4476                	lw	s0,92(sp)
80007be4:	00ab6533          	or	a0,s6,a0
80007be8:	00a03533          	snez	a0,a0
80007bec:	8d89                	sub	a1,a1,a0
80007bee:	013c1513          	slli	a0,s8,0x13
80007bf2:	ffb58a93          	addi	s5,a1,-5 # 411ffffb <__NONCACHEABLE_RAM_segment_end__+0x3ffbfffb>
80007bf6:	00054463          	bltz	a0,80007bfe <__SEGGER_RTL_vfprintf+0xac8>
80007bfa:	4c85                	li	s9,1
80007bfc:	a891                	j	80007c50 <__SEGGER_RTL_vfprintf+0xb1a>
80007bfe:	4502                	lw	a0,0(sp)
80007c00:	02a41533          	mulh	a0,s0,a0
80007c04:	01f55593          	srli	a1,a0,0x1f
80007c08:	952e                	add	a0,a0,a1
80007c0a:	00151593          	slli	a1,a0,0x1
80007c0e:	40a40533          	sub	a0,s0,a0
80007c12:	8d0d                	sub	a0,a0,a1
80007c14:	0509                	addi	a0,a0,2
80007c16:	050a                	slli	a0,a0,0x2
80007c18:	d3818593          	addi	a1,gp,-712 # 80003e6c <.LJTI0_3>
80007c1c:	952e                	add	a0,a0,a1
80007c1e:	4108                	lw	a0,0(a0)
80007c20:	4b89                	li	s7,2
80007c22:	54fd                	li	s1,-1
80007c24:	412005b7          	lui	a1,0x41200
80007c28:	4c85                	li	s9,1
80007c2a:	8502                	jr	a0
80007c2c:	4b8d                	li	s7,3
80007c2e:	54f9                	li	s1,-2
80007c30:	42c805b7          	lui	a1,0x42c80
80007c34:	5512                	lw	a0,36(sp)
80007c36:	3ba020ef          	jal	80009ff0 <__mulsf3>
80007c3a:	d22a                	sw	a0,36(sp)
80007c3c:	9426                	add	s0,s0,s1
80007c3e:	cea2                	sw	s0,92(sp)
80007c40:	9aa6                	add	s5,s5,s1
80007c42:	8cde                	mv	s9,s7
80007c44:	01602533          	sgtz	a0,s6
80007c48:	40a00533          	neg	a0,a0
80007c4c:	01657b33          	and	s6,a0,s6
80007c50:	4542                	lw	a0,16(sp)
80007c52:	00ac7bb3          	and	s7,s8,a0
80007c56:	060c7513          	andi	a0,s8,96
80007c5a:	00a03533          	snez	a0,a0
80007c5e:	40aa84b3          	sub	s1,s5,a0
80007c62:	8522                	mv	a0,s0
80007c64:	9caff0ef          	jal	80006e2e <abs>
80007c68:	06452513          	slti	a0,a0,100
80007c6c:	00154513          	xori	a0,a0,1
80007c70:	40a48ab3          	sub	s5,s1,a0
80007c74:	5c12                	lw	s8,36(sp)
80007c76:	8562                	mv	a0,s8
80007c78:	554020ef          	jal	8000a1cc <__fixunssfdi>
80007c7c:	842a                	mv	s0,a0
80007c7e:	84ae                	mv	s1,a1
80007c80:	f6dfe0ef          	jal	80006bec <__floatundisf>
80007c84:	85aa                	mv	a1,a0
80007c86:	8562                	mv	a0,s8
80007c88:	b97fe0ef          	jal	8000681e <__subsf3>
80007c8c:	d22a                	sw	a0,36(sp)
80007c8e:	01502533          	sgtz	a0,s5
80007c92:	40a00533          	neg	a0,a0
80007c96:	210bf593          	andi	a1,s7,528
80007c9a:	01557c33          	and	s8,a0,s5
80007c9e:	e999                	bnez	a1,80007cb4 <__SEGGER_RTL_vfprintf+0xb7e>
80007ca0:	01505a63          	blez	s5,80007cb4 <__SEGGER_RTL_vfprintf+0xb7e>
80007ca4:	1c7d                	addi	s8,s8,-1
80007ca6:	02000593          	li	a1,32
80007caa:	8552                	mv	a0,s4
80007cac:	ab0ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007cb0:	fe0c1ae3          	bnez	s8,80007ca4 <__SEGGER_RTL_vfprintf+0xb6e>
80007cb4:	80003ab7          	lui	s5,0x80003
80007cb8:	068a8a93          	addi	s5,s5,104 # 80003068 <__SEGGER_RTL_ipow10>
80007cbc:	020bf593          	andi	a1,s7,32
80007cc0:	040bf513          	andi	a0,s7,64
80007cc4:	e589                	bnez	a1,80007cce <__SEGGER_RTL_vfprintf+0xb98>
80007cc6:	cd09                	beqz	a0,80007ce0 <__SEGGER_RTL_vfprintf+0xbaa>
80007cc8:	02000593          	li	a1,32
80007ccc:	a039                	j	80007cda <__SEGGER_RTL_vfprintf+0xba4>
80007cce:	c501                	beqz	a0,80007cd6 <__SEGGER_RTL_vfprintf+0xba0>
80007cd0:	02d00593          	li	a1,45
80007cd4:	a019                	j	80007cda <__SEGGER_RTL_vfprintf+0xba4>
80007cd6:	02b00593          	li	a1,43
80007cda:	8552                	mv	a0,s4
80007cdc:	a80ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007ce0:	010bf513          	andi	a0,s7,16
80007ce4:	e919                	bnez	a0,80007cfa <__SEGGER_RTL_vfprintf+0xbc4>
80007ce6:	000c0a63          	beqz	s8,80007cfa <__SEGGER_RTL_vfprintf+0xbc4>
80007cea:	1c7d                	addi	s8,s8,-1
80007cec:	03000593          	li	a1,48
80007cf0:	8552                	mv	a0,s4
80007cf2:	a6aff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007cf6:	fe0c1ae3          	bnez	s8,80007cea <__SEGGER_RTL_vfprintf+0xbb4>
80007cfa:	1cfd                	addi	s9,s9,-1
80007cfc:	003c9513          	slli	a0,s9,0x3
80007d00:	00aa85b3          	add	a1,s5,a0
80007d04:	41c8                	lw	a0,4(a1)
80007d06:	418c                	lw	a1,0(a1)
80007d08:	02a48863          	beq	s1,a0,80007d38 <__SEGGER_RTL_vfprintf+0xc02>
80007d0c:	00a4b633          	sltu	a2,s1,a0
80007d10:	e61d                	bnez	a2,80007d3e <__SEGGER_RTL_vfprintf+0xc08>
80007d12:	03000613          	li	a2,48
80007d16:	00b436b3          	sltu	a3,s0,a1
80007d1a:	8c89                	sub	s1,s1,a0
80007d1c:	8c95                	sub	s1,s1,a3
80007d1e:	8c0d                	sub	s0,s0,a1
80007d20:	00a48563          	beq	s1,a0,80007d2a <__SEGGER_RTL_vfprintf+0xbf4>
80007d24:	00a4b6b3          	sltu	a3,s1,a0
80007d28:	a019                	j	80007d2e <__SEGGER_RTL_vfprintf+0xbf8>
80007d2a:	00b436b3          	sltu	a3,s0,a1
80007d2e:	0605                	addi	a2,a2,1
80007d30:	d2fd                	beqz	a3,80007d16 <__SEGGER_RTL_vfprintf+0xbe0>
80007d32:	0ff67593          	zext.b	a1,a2
80007d36:	a031                	j	80007d42 <__SEGGER_RTL_vfprintf+0xc0c>
80007d38:	00b43633          	sltu	a2,s0,a1
80007d3c:	da79                	beqz	a2,80007d12 <__SEGGER_RTL_vfprintf+0xbdc>
80007d3e:	03000593          	li	a1,48
80007d42:	8552                	mv	a0,s4
80007d44:	a18ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007d48:	fa0c99e3          	bnez	s9,80007cfa <__SEGGER_RTL_vfprintf+0xbc4>
80007d4c:	5502                	lw	a0,32(sp)
80007d4e:	c0050513          	addi	a0,a0,-1024
80007d52:	00abf433          	and	s0,s7,a0
80007d56:	cc01                	beqz	s0,80007d6e <__SEGGER_RTL_vfprintf+0xc38>
80007d58:	4576                	lw	a0,92(sp)
80007d5a:	00a05a63          	blez	a0,80007d6e <__SEGGER_RTL_vfprintf+0xc38>
80007d5e:	157d                	addi	a0,a0,-1
80007d60:	ceaa                	sw	a0,92(sp)
80007d62:	03000593          	li	a1,48
80007d66:	8552                	mv	a0,s4
80007d68:	9f4ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007d6c:	b7f5                	j	80007d58 <__SEGGER_RTL_vfprintf+0xc22>
80007d6e:	080bf513          	andi	a0,s7,128
80007d72:	00ab6533          	or	a0,s6,a0
80007d76:	54b2                	lw	s1,44(sp)
80007d78:	cd55                	beqz	a0,80007e34 <__SEGGER_RTL_vfprintf+0xcfe>
80007d7a:	02e00593          	li	a1,46
80007d7e:	8552                	mv	a0,s4
80007d80:	9dcff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007d84:	45c1                	li	a1,16
80007d86:	855a                	mv	a0,s6
80007d88:	00bb4363          	blt	s6,a1,80007d8e <__SEGGER_RTL_vfprintf+0xc58>
80007d8c:	4541                	li	a0,16
80007d8e:	00a025b3          	sgtz	a1,a0
80007d92:	4676                	lw	a2,92(sp)
80007d94:	40b005b3          	neg	a1,a1
80007d98:	00a5fcb3          	and	s9,a1,a0
80007d9c:	00143513          	seqz	a0,s0
80007da0:	157d                	addi	a0,a0,-1
80007da2:	8d71                	and	a0,a0,a2
80007da4:	40ac8533          	sub	a0,s9,a0
80007da8:	0f2030ef          	jal	8000ae9a <__SEGGER_RTL_pow10f>
80007dac:	07605763          	blez	s6,80007e1a <__SEGGER_RTL_vfprintf+0xce4>
80007db0:	85aa                	mv	a1,a0
80007db2:	5512                	lw	a0,36(sp)
80007db4:	23c020ef          	jal	80009ff0 <__mulsf3>
80007db8:	414020ef          	jal	8000a1cc <__fixunssfdi>
80007dbc:	842a                	mv	s0,a0
80007dbe:	84ae                	mv	s1,a1
80007dc0:	8ae6                	mv	s5,s9
80007dc2:	1afd                	addi	s5,s5,-1
80007dc4:	003a9513          	slli	a0,s5,0x3
80007dc8:	800035b7          	lui	a1,0x80003
80007dcc:	06858593          	addi	a1,a1,104 # 80003068 <__SEGGER_RTL_ipow10>
80007dd0:	95aa                	add	a1,a1,a0
80007dd2:	41c8                	lw	a0,4(a1)
80007dd4:	418c                	lw	a1,0(a1)
80007dd6:	02a48863          	beq	s1,a0,80007e06 <__SEGGER_RTL_vfprintf+0xcd0>
80007dda:	00a4b633          	sltu	a2,s1,a0
80007dde:	e61d                	bnez	a2,80007e0c <__SEGGER_RTL_vfprintf+0xcd6>
80007de0:	03000613          	li	a2,48
80007de4:	00b436b3          	sltu	a3,s0,a1
80007de8:	8c89                	sub	s1,s1,a0
80007dea:	8c95                	sub	s1,s1,a3
80007dec:	8c0d                	sub	s0,s0,a1
80007dee:	00a48563          	beq	s1,a0,80007df8 <__SEGGER_RTL_vfprintf+0xcc2>
80007df2:	00a4b6b3          	sltu	a3,s1,a0
80007df6:	a019                	j	80007dfc <__SEGGER_RTL_vfprintf+0xcc6>
80007df8:	00b436b3          	sltu	a3,s0,a1
80007dfc:	0605                	addi	a2,a2,1
80007dfe:	d2fd                	beqz	a3,80007de4 <__SEGGER_RTL_vfprintf+0xcae>
80007e00:	0ff67593          	zext.b	a1,a2
80007e04:	a031                	j	80007e10 <__SEGGER_RTL_vfprintf+0xcda>
80007e06:	00b43633          	sltu	a2,s0,a1
80007e0a:	da79                	beqz	a2,80007de0 <__SEGGER_RTL_vfprintf+0xcaa>
80007e0c:	03000593          	li	a1,48
80007e10:	8552                	mv	a0,s4
80007e12:	94aff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007e16:	fa0a96e3          	bnez	s5,80007dc2 <__SEGGER_RTL_vfprintf+0xc8c>
80007e1a:	419b0533          	sub	a0,s6,s9
80007e1e:	54b2                	lw	s1,44(sp)
80007e20:	c911                	beqz	a0,80007e34 <__SEGGER_RTL_vfprintf+0xcfe>
80007e22:	416c8433          	sub	s0,s9,s6
80007e26:	03000593          	li	a1,48
80007e2a:	8552                	mv	a0,s4
80007e2c:	930ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007e30:	0405                	addi	s0,s0,1
80007e32:	f875                	bnez	s0,80007e26 <__SEGGER_RTL_vfprintf+0xcf0>
80007e34:	400bf513          	andi	a0,s7,1024
80007e38:	02500c93          	li	s9,37
80007e3c:	c969                	beqz	a0,80007f0e <__SEGGER_RTL_vfprintf+0xdd8>
80007e3e:	0bca                	slli	s7,s7,0x12
80007e40:	41fbd513          	srai	a0,s7,0x1f
80007e44:	9901                	andi	a0,a0,-32
80007e46:	06550593          	addi	a1,a0,101
80007e4a:	8552                	mv	a0,s4
80007e4c:	910ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007e50:	4576                	lw	a0,92(sp)
80007e52:	00054963          	bltz	a0,80007e64 <__SEGGER_RTL_vfprintf+0xd2e>
80007e56:	02b00593          	li	a1,43
80007e5a:	8552                	mv	a0,s4
80007e5c:	900ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007e60:	4576                	lw	a0,92(sp)
80007e62:	a811                	j	80007e76 <__SEGGER_RTL_vfprintf+0xd40>
80007e64:	02d00593          	li	a1,45
80007e68:	8552                	mv	a0,s4
80007e6a:	8f2ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007e6e:	4576                	lw	a0,92(sp)
80007e70:	40a00533          	neg	a0,a0
80007e74:	ceaa                	sw	a0,92(sp)
80007e76:	06400493          	li	s1,100
80007e7a:	02954663          	blt	a0,s1,80007ea6 <__SEGGER_RTL_vfprintf+0xd70>
80007e7e:	4422                	lw	s0,8(sp)
80007e80:	02853533          	mulhu	a0,a0,s0
80007e84:	8115                	srli	a0,a0,0x5
80007e86:	03050593          	addi	a1,a0,48
80007e8a:	8552                	mv	a0,s4
80007e8c:	8d0ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007e90:	4576                	lw	a0,92(sp)
80007e92:	028515b3          	mulh	a1,a0,s0
80007e96:	01f5d613          	srli	a2,a1,0x1f
80007e9a:	8595                	srai	a1,a1,0x5
80007e9c:	95b2                	add	a1,a1,a2
80007e9e:	029585b3          	mul	a1,a1,s1
80007ea2:	8d0d                	sub	a0,a0,a1
80007ea4:	ceaa                	sw	a0,92(sp)
80007ea6:	54b2                	lw	s1,44(sp)
80007ea8:	4462                	lw	s0,24(sp)
80007eaa:	02851533          	mulh	a0,a0,s0
80007eae:	01f55593          	srli	a1,a0,0x1f
80007eb2:	8509                	srai	a0,a0,0x2
80007eb4:	952e                	add	a0,a0,a1
80007eb6:	03050593          	addi	a1,a0,48
80007eba:	8552                	mv	a0,s4
80007ebc:	8a0ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007ec0:	4576                	lw	a0,92(sp)
80007ec2:	028515b3          	mulh	a1,a0,s0
80007ec6:	01f5d613          	srli	a2,a1,0x1f
80007eca:	8589                	srai	a1,a1,0x2
80007ecc:	95b2                	add	a1,a1,a2
80007ece:	033585b3          	mul	a1,a1,s3
80007ed2:	8d0d                	sub	a0,a0,a1
80007ed4:	03050593          	addi	a1,a0,48
80007ed8:	a805                	j	80007f08 <__SEGGER_RTL_vfprintf+0xdd2>
80007eda:	5aa2                	lw	s5,40(sp)
80007edc:	c591                	beqz	a1,80007ee8 <__SEGGER_RTL_vfprintf+0xdb2>
80007ede:	8000b5b7          	lui	a1,0x8000b
80007ee2:	06358593          	addi	a1,a1,99 # 8000b063 <.L.str.3>
80007ee6:	a029                	j	80007ef0 <__SEGGER_RTL_vfprintf+0xdba>
80007ee8:	8000b5b7          	lui	a1,0x8000b
80007eec:	06858593          	addi	a1,a1,104 # 8000b068 <.L.str.4>
80007ef0:	00158513          	addi	a0,a1,1
80007ef4:	020c7613          	andi	a2,s8,32
80007ef8:	c211                	beqz	a2,80007efc <__SEGGER_RTL_vfprintf+0xdc6>
80007efa:	852e                	mv	a0,a1
80007efc:	effc7b93          	andi	s7,s8,-257
80007f00:	837ff06f          	j	80007736 <__SEGGER_RTL_vfprintf+0x600>
80007f04:	8b5e                	mv	s6,s7
80007f06:	b9c9                	j	80007bd8 <__SEGGER_RTL_vfprintf+0xaa2>
80007f08:	8552                	mv	a0,s4
80007f0a:	852ff0ef          	jal	80006f5c <__SEGGER_RTL_putc>
80007f0e:	a80c0563          	beqz	s8,80007198 <__SEGGER_RTL_vfprintf+0x62>
80007f12:	1c7d                	addi	s8,s8,-1
80007f14:	02000593          	li	a1,32
80007f18:	bfc5                	j	80007f08 <__SEGGER_RTL_vfprintf+0xdd2>
80007f1a:	00ca2503          	lw	a0,12(s4)
80007f1e:	c911                	beqz	a0,80007f32 <__SEGGER_RTL_vfprintf+0xdfc>
80007f20:	000a2583          	lw	a1,0(s4)
80007f24:	004a2603          	lw	a2,4(s4)
80007f28:	00c5f563          	bgeu	a1,a2,80007f32 <__SEGGER_RTL_vfprintf+0xdfc>
80007f2c:	952e                	add	a0,a0,a1
80007f2e:	00050023          	sb	zero,0(a0)
80007f32:	8552                	mv	a0,s4
80007f34:	8c8ff0ef          	jal	80006ffc <__SEGGER_RTL_prin_flush>
80007f38:	000a2503          	lw	a0,0(s4)
80007f3c:	6125                	addi	sp,sp,96
80007f3e:	7970106f          	j	80009ed4 <__riscv_restore_12>
80007f42:	8552                	mv	a0,s4
80007f44:	8b8ff0ef          	jal	80006ffc <__SEGGER_RTL_prin_flush>
80007f48:	557d                	li	a0,-1
80007f4a:	bfcd                	j	80007f3c <__SEGGER_RTL_vfprintf+0xe06>

Disassembly of section .segger.init.__SEGGER_init_heap:

80007f4c <__SEGGER_init_heap>:
80007f4c:	00200537          	lui	a0,0x200
80007f50:	00050513          	mv	a0,a0

80007f54 <.Lpcrel_hi1>:
80007f54:	002045b7          	lui	a1,0x204
80007f58:	00058593          	mv	a1,a1
80007f5c:	8d89                	sub	a1,a1,a0
80007f5e:	a009                	j	80007f60 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

80007f60 <__SEGGER_RTL_init_heap>:
80007f60:	4621                	li	a2,8
80007f62:	00c5e963          	bltu	a1,a2,80007f74 <__SEGGER_RTL_init_heap+0x14>
80007f66:	01200637          	lui	a2,0x1200
80007f6a:	04a62623          	sw	a0,76(a2) # 120004c <__SEGGER_RTL_heap_globals.0>
80007f6e:	00052023          	sw	zero,0(a0) # 200000 <__DLM_segment_start__>
80007f72:	c14c                	sw	a1,4(a0)
80007f74:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

80007f76 <__SEGGER_RTL_ascii_toupper>:
80007f76:	f9f50593          	addi	a1,a0,-97
80007f7a:	01a5b593          	sltiu	a1,a1,26
80007f7e:	40b005b3          	neg	a1,a1
80007f82:	9981                	andi	a1,a1,-32
80007f84:	952e                	add	a0,a0,a1
80007f86:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

80007f88 <__SEGGER_RTL_ascii_tolower>:
80007f88:	fbf50593          	addi	a1,a0,-65
80007f8c:	01a5b593          	sltiu	a1,a1,26
80007f90:	0596                	slli	a1,a1,0x5
80007f92:	8d4d                	or	a0,a0,a1
80007f94:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

80007f96 <__SEGGER_RTL_ascii_towupper>:
80007f96:	f9f50593          	addi	a1,a0,-97
80007f9a:	01a5b593          	sltiu	a1,a1,26
80007f9e:	40b005b3          	neg	a1,a1
80007fa2:	9981                	andi	a1,a1,-32
80007fa4:	952e                	add	a0,a0,a1
80007fa6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

80007fa8 <__SEGGER_RTL_ascii_towlower>:
80007fa8:	fbf50593          	addi	a1,a0,-65
80007fac:	01a5b593          	sltiu	a1,a1,26
80007fb0:	0596                	slli	a1,a1,0x5
80007fb2:	8d4d                	or	a0,a0,a1
80007fb4:	8082                	ret

Disassembly of section .text.pwmv2_shadow_register_lock:

80007fb6 <pwmv2_shadow_register_lock>:
{
80007fb6:	1141                	addi	sp,sp,-16
80007fb8:	c62a                	sw	a0,12(sp)
    pwm_x->WORK_CTRL1 |= PWMV2_WORK_CTRL1_SHADOW_LOCK_MASK;
80007fba:	47b2                	lw	a5,12(sp)
80007fbc:	5ff8                	lw	a4,124(a5)
80007fbe:	800007b7          	lui	a5,0x80000
80007fc2:	8f5d                	or	a4,a4,a5
80007fc4:	47b2                	lw	a5,12(sp)
80007fc6:	dff8                	sw	a4,124(a5)
}
80007fc8:	0001                	nop
80007fca:	0141                	addi	sp,sp,16
80007fcc:	8082                	ret

Disassembly of section .text.pwmv2_set_shadow_val:

80007fce <pwmv2_set_shadow_val>:
{
80007fce:	1141                	addi	sp,sp,-16
80007fd0:	c62a                	sw	a0,12(sp)
80007fd2:	87ae                	mv	a5,a1
80007fd4:	c232                	sw	a2,4(sp)
80007fd6:	00f105a3          	sb	a5,11(sp)
80007fda:	87b6                	mv	a5,a3
80007fdc:	00f10523          	sb	a5,10(sp)
80007fe0:	87ba                	mv	a5,a4
80007fe2:	00f104a3          	sb	a5,9(sp)
    pwm_x->SHADOW_VAL[index] = PWMV2_SHADOW_VAL_VALUE_SET(((value << 8) | (enable_half_cycle << 7) | (high_resolution_tick)));
80007fe6:	4792                	lw	a5,4(sp)
80007fe8:	00879713          	slli	a4,a5,0x8
80007fec:	00914783          	lbu	a5,9(sp)
80007ff0:	079e                	slli	a5,a5,0x7
80007ff2:	00f766b3          	or	a3,a4,a5
80007ff6:	00a14703          	lbu	a4,10(sp)
80007ffa:	00b14783          	lbu	a5,11(sp)
80007ffe:	8f55                	or	a4,a4,a3
80008000:	46b2                	lw	a3,12(sp)
80008002:	078a                	slli	a5,a5,0x2
80008004:	97b6                	add	a5,a5,a3
80008006:	c798                	sw	a4,8(a5)
}
80008008:	0001                	nop
8000800a:	0141                	addi	sp,sp,16
8000800c:	8082                	ret

Disassembly of section .text.pwmv2_disable_four_cmp:

8000800e <pwmv2_disable_four_cmp>:
{
8000800e:	1141                	addi	sp,sp,-16
80008010:	c62a                	sw	a0,12(sp)
80008012:	87ae                	mv	a5,a1
80008014:	00f105a3          	sb	a5,11(sp)
    pwm_x->PWM[chn].CFG0 &= ~PWMV2_PWM_CFG0_TRIG_SEL4_MASK;
80008018:	00b14783          	lbu	a5,11(sp)
8000801c:	4732                	lw	a4,12(sp)
8000801e:	07c1                	addi	a5,a5,16 # 80000010 <__NONCACHEABLE_RAM_segment_end__+0x7edc0010>
80008020:	0792                	slli	a5,a5,0x4
80008022:	97ba                	add	a5,a5,a4
80008024:	4394                	lw	a3,0(a5)
80008026:	00b14783          	lbu	a5,11(sp)
8000802a:	ff000737          	lui	a4,0xff000
8000802e:	177d                	addi	a4,a4,-1 # feffffff <__AHB_SRAM_segment_end__+0xedf7fff>
80008030:	8f75                	and	a4,a4,a3
80008032:	46b2                	lw	a3,12(sp)
80008034:	07c1                	addi	a5,a5,16
80008036:	0792                	slli	a5,a5,0x4
80008038:	97b6                	add	a5,a5,a3
8000803a:	c398                	sw	a4,0(a5)
}
8000803c:	0001                	nop
8000803e:	0141                	addi	sp,sp,16
80008040:	8082                	ret

Disassembly of section .text.pwmv2_enable_async_fault:

80008042 <pwmv2_enable_async_fault>:
{
80008042:	1141                	addi	sp,sp,-16
80008044:	c62a                	sw	a0,12(sp)
80008046:	87ae                	mv	a5,a1
80008048:	00f105a3          	sb	a5,11(sp)
    pwm_x->PWM[chn].CFG0 |= PWMV2_PWM_CFG0_FAULT_EN_ASYNC_MASK;
8000804c:	00b14783          	lbu	a5,11(sp)
80008050:	4732                	lw	a4,12(sp)
80008052:	07c1                	addi	a5,a5,16
80008054:	0792                	slli	a5,a5,0x4
80008056:	97ba                	add	a5,a5,a4
80008058:	4398                	lw	a4,0(a5)
8000805a:	00b14783          	lbu	a5,11(sp)
8000805e:	02076713          	ori	a4,a4,32
80008062:	46b2                	lw	a3,12(sp)
80008064:	07c1                	addi	a5,a5,16
80008066:	0792                	slli	a5,a5,0x4
80008068:	97b6                	add	a5,a5,a3
8000806a:	c398                	sw	a4,0(a5)
}
8000806c:	0001                	nop
8000806e:	0141                	addi	sp,sp,16
80008070:	8082                	ret

Disassembly of section .text.pwmv2_enable_output_invert:

80008072 <pwmv2_enable_output_invert>:
{
80008072:	1141                	addi	sp,sp,-16
80008074:	c62a                	sw	a0,12(sp)
80008076:	87ae                	mv	a5,a1
80008078:	00f105a3          	sb	a5,11(sp)
    pwm_x->PWM[chn].CFG0 |= PWMV2_PWM_CFG0_OUT_POLARITY_MASK;
8000807c:	00b14783          	lbu	a5,11(sp)
80008080:	4732                	lw	a4,12(sp)
80008082:	07c1                	addi	a5,a5,16
80008084:	0792                	slli	a5,a5,0x4
80008086:	97ba                	add	a5,a5,a4
80008088:	4398                	lw	a4,0(a5)
8000808a:	00b14783          	lbu	a5,11(sp)
8000808e:	00276713          	ori	a4,a4,2
80008092:	46b2                	lw	a3,12(sp)
80008094:	07c1                	addi	a5,a5,16
80008096:	0792                	slli	a5,a5,0x4
80008098:	97b6                	add	a5,a5,a3
8000809a:	c398                	sw	a4,0(a5)
}
8000809c:	0001                	nop
8000809e:	0141                	addi	sp,sp,16
800080a0:	8082                	ret

Disassembly of section .text.pwmv2_channel_disable_output:

800080a2 <pwmv2_channel_disable_output>:
{
800080a2:	1141                	addi	sp,sp,-16
800080a4:	c62a                	sw	a0,12(sp)
800080a6:	87ae                	mv	a5,a1
800080a8:	00f105a3          	sb	a5,11(sp)
    pwm_x->PWM[chn].CFG1 &= ~PWMV2_PWM_CFG1_HIGHZ_EN_N_MASK;
800080ac:	00b14783          	lbu	a5,11(sp)
800080b0:	4732                	lw	a4,12(sp)
800080b2:	07c1                	addi	a5,a5,16
800080b4:	0792                	slli	a5,a5,0x4
800080b6:	97ba                	add	a5,a5,a4
800080b8:	43d4                	lw	a3,4(a5)
800080ba:	00b14783          	lbu	a5,11(sp)
800080be:	f0000737          	lui	a4,0xf0000
800080c2:	177d                	addi	a4,a4,-1 # efffffff <__FLASH_segment_end__+0x6fefffff>
800080c4:	8f75                	and	a4,a4,a3
800080c6:	46b2                	lw	a3,12(sp)
800080c8:	07c1                	addi	a5,a5,16
800080ca:	0792                	slli	a5,a5,0x4
800080cc:	97b6                	add	a5,a5,a3
800080ce:	c3d8                	sw	a4,4(a5)
}
800080d0:	0001                	nop
800080d2:	0141                	addi	sp,sp,16
800080d4:	8082                	ret

Disassembly of section .text.pwmv2_set_reload_update_time:

800080d6 <pwmv2_set_reload_update_time>:
{
800080d6:	1141                	addi	sp,sp,-16
800080d8:	c62a                	sw	a0,12(sp)
800080da:	87ae                	mv	a5,a1
800080dc:	8732                	mv	a4,a2
800080de:	00f105a3          	sb	a5,11(sp)
800080e2:	87ba                	mv	a5,a4
800080e4:	00f10523          	sb	a5,10(sp)
    pwm_x->CNT[counter].CFG0 = (pwm_x->CNT[counter].CFG0 & ~(PWMV2_CNT_CFG0_RLD_UPDATE_TIME_MASK)) | PWMV2_CNT_CFG0_RLD_UPDATE_TIME_SET(update);
800080e8:	00b14783          	lbu	a5,11(sp)
800080ec:	4732                	lw	a4,12(sp)
800080ee:	05078793          	addi	a5,a5,80
800080f2:	0792                	slli	a5,a5,0x4
800080f4:	97ba                	add	a5,a5,a4
800080f6:	439c                	lw	a5,0(a5)
800080f8:	cff7f693          	andi	a3,a5,-769
800080fc:	00a14783          	lbu	a5,10(sp)
80008100:	07a2                	slli	a5,a5,0x8
80008102:	3007f713          	andi	a4,a5,768
80008106:	00b14783          	lbu	a5,11(sp)
8000810a:	8f55                	or	a4,a4,a3
8000810c:	46b2                	lw	a3,12(sp)
8000810e:	05078793          	addi	a5,a5,80
80008112:	0792                	slli	a5,a5,0x4
80008114:	97b6                	add	a5,a5,a3
80008116:	c398                	sw	a4,0(a5)
}
80008118:	0001                	nop
8000811a:	0141                	addi	sp,sp,16
8000811c:	8082                	ret

Disassembly of section .text.pwmv2_reset_counter:

8000811e <pwmv2_reset_counter>:
{
8000811e:	1141                	addi	sp,sp,-16
80008120:	c62a                	sw	a0,12(sp)
80008122:	87ae                	mv	a5,a1
80008124:	00f105a3          	sb	a5,11(sp)
    pwm_x->CNT_GLBCFG |= PWMV2_CNT_GLBCFG_TIMER_RESET_SET((1 << counter));
80008128:	47b2                	lw	a5,12(sp)
8000812a:	5407a703          	lw	a4,1344(a5)
8000812e:	00b14783          	lbu	a5,11(sp)
80008132:	4685                	li	a3,1
80008134:	00f697b3          	sll	a5,a3,a5
80008138:	00879693          	slli	a3,a5,0x8
8000813c:	6785                	lui	a5,0x1
8000813e:	f0078793          	addi	a5,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
80008142:	8ff5                	and	a5,a5,a3
80008144:	8f5d                	or	a4,a4,a5
80008146:	47b2                	lw	a5,12(sp)
80008148:	54e7a023          	sw	a4,1344(a5)
}
8000814c:	0001                	nop
8000814e:	0141                	addi	sp,sp,16
80008150:	8082                	ret

Disassembly of section .text.adc16_get_status_flags:

80008152 <adc16_get_status_flags>:
 * @param[in] ptr An ADC16 peripheral base address.
 * @return A mask indicating all corresponding interrupt statuses.
 * @retval A mask. Please refer to @ref adc16_irq_event_t.
 */
static inline uint32_t adc16_get_status_flags(ADC16_Type *ptr)
{
80008152:	1141                	addi	sp,sp,-16
80008154:	c62a                	sw	a0,12(sp)
    return ptr->INT_STS;
80008156:	4732                	lw	a4,12(sp)
80008158:	6785                	lui	a5,0x1
8000815a:	97ba                	add	a5,a5,a4
8000815c:	1107a783          	lw	a5,272(a5) # 1110 <__NONCACHEABLE_RAM_segment_used_size__+0x50>
}
80008160:	853e                	mv	a0,a5
80008162:	0141                	addi	sp,sp,16
80008164:	8082                	ret

Disassembly of section .text.adc16_clear_status_flags:

80008166 <adc16_clear_status_flags>:
 * @param[in] mask A mask that means the specified flags to be cleared. Please refer to @ref adc16_irq_event_t.
 *
 * @note Only the specified flags can be cleared by writing the INT_STS register.
 */
static inline void adc16_clear_status_flags(ADC16_Type *ptr, uint32_t mask)
{
80008166:	1141                	addi	sp,sp,-16
80008168:	c62a                	sw	a0,12(sp)
8000816a:	c42e                	sw	a1,8(sp)
    ptr->INT_STS = mask;
8000816c:	4732                	lw	a4,12(sp)
8000816e:	6785                	lui	a5,0x1
80008170:	97ba                	add	a5,a5,a4
80008172:	4722                	lw	a4,8(sp)
80008174:	10e7a823          	sw	a4,272(a5) # 1110 <__NONCACHEABLE_RAM_segment_used_size__+0x50>
}
80008178:	0001                	nop
8000817a:	0141                	addi	sp,sp,16
8000817c:	8082                	ret

Disassembly of section .text.adc16_enable_interrupts:

8000817e <adc16_enable_interrupts>:
 *
 * @param[in] ptr An ADC16 peripheral base address.
 * @param[in] mask A mask indicating the specified ADC interrupt events. Please refer to @ref adc16_irq_event_t.
 */
static inline void adc16_enable_interrupts(ADC16_Type *ptr, uint32_t mask)
{
8000817e:	1141                	addi	sp,sp,-16
80008180:	c62a                	sw	a0,12(sp)
80008182:	c42e                	sw	a1,8(sp)
    ptr->INT_EN |= mask;
80008184:	4732                	lw	a4,12(sp)
80008186:	6785                	lui	a5,0x1
80008188:	97ba                	add	a5,a5,a4
8000818a:	1147a703          	lw	a4,276(a5) # 1114 <__NONCACHEABLE_RAM_segment_used_size__+0x54>
8000818e:	47a2                	lw	a5,8(sp)
80008190:	8f5d                	or	a4,a4,a5
80008192:	46b2                	lw	a3,12(sp)
80008194:	6785                	lui	a5,0x1
80008196:	97b6                	add	a5,a5,a3
80008198:	10e7aa23          	sw	a4,276(a5) # 1114 <__NONCACHEABLE_RAM_segment_used_size__+0x54>
}
8000819c:	0001                	nop
8000819e:	0141                	addi	sp,sp,16
800081a0:	8082                	ret

Disassembly of section .text.gpio_set_pin_input:

800081a2 <gpio_set_pin_input>:
{
800081a2:	1141                	addi	sp,sp,-16
800081a4:	c62a                	sw	a0,12(sp)
800081a6:	c42e                	sw	a1,8(sp)
800081a8:	87b2                	mv	a5,a2
800081aa:	00f103a3          	sb	a5,7(sp)
    ptr->OE[port].CLEAR = 1 << pin;
800081ae:	00714783          	lbu	a5,7(sp)
800081b2:	4705                	li	a4,1
800081b4:	00f717b3          	sll	a5,a4,a5
800081b8:	86be                	mv	a3,a5
800081ba:	4732                	lw	a4,12(sp)
800081bc:	47a2                	lw	a5,8(sp)
800081be:	02078793          	addi	a5,a5,32
800081c2:	0792                	slli	a5,a5,0x4
800081c4:	97ba                	add	a5,a5,a4
800081c6:	c794                	sw	a3,8(a5)
}
800081c8:	0001                	nop
800081ca:	0141                	addi	sp,sp,16
800081cc:	8082                	ret

Disassembly of section .text.gpio_clear_pin_interrupt_flag:

800081ce <gpio_clear_pin_interrupt_flag>:
{
800081ce:	1141                	addi	sp,sp,-16
800081d0:	c62a                	sw	a0,12(sp)
800081d2:	c42e                	sw	a1,8(sp)
800081d4:	87b2                	mv	a5,a2
800081d6:	00f103a3          	sb	a5,7(sp)
    ptr->IF[port].VALUE = 1 << pin;
800081da:	00714783          	lbu	a5,7(sp)
800081de:	4705                	li	a4,1
800081e0:	00f717b3          	sll	a5,a4,a5
800081e4:	86be                	mv	a3,a5
800081e6:	4732                	lw	a4,12(sp)
800081e8:	47a2                	lw	a5,8(sp)
800081ea:	03078793          	addi	a5,a5,48
800081ee:	0792                	slli	a5,a5,0x4
800081f0:	97ba                	add	a5,a5,a4
800081f2:	c394                	sw	a3,0(a5)
}
800081f4:	0001                	nop
800081f6:	0141                	addi	sp,sp,16
800081f8:	8082                	ret

Disassembly of section .text.gpio_enable_pin_interrupt:

800081fa <gpio_enable_pin_interrupt>:
{
800081fa:	1141                	addi	sp,sp,-16
800081fc:	c62a                	sw	a0,12(sp)
800081fe:	c42e                	sw	a1,8(sp)
80008200:	87b2                	mv	a5,a2
80008202:	00f103a3          	sb	a5,7(sp)
    ptr->IE[port].SET = 1 << pin;
80008206:	00714783          	lbu	a5,7(sp)
8000820a:	4705                	li	a4,1
8000820c:	00f717b3          	sll	a5,a4,a5
80008210:	86be                	mv	a3,a5
80008212:	4732                	lw	a4,12(sp)
80008214:	47a2                	lw	a5,8(sp)
80008216:	04078793          	addi	a5,a5,64
8000821a:	0792                	slli	a5,a5,0x4
8000821c:	97ba                	add	a5,a5,a4
8000821e:	c3d4                	sw	a3,4(a5)
}
80008220:	0001                	nop
80008222:	0141                	addi	sp,sp,16
80008224:	8082                	ret

Disassembly of section .text.init_synt_timebase:

80008226 <init_synt_timebase>:
{
80008226:	1141                	addi	sp,sp,-16
80008228:	c606                	sw	ra,12(sp)
    synt_reset_counter(HPM_SYNT);
8000822a:	f0464537          	lui	a0,0xf0464
8000822e:	cf2fc0ef          	jal	80004720 <synt_reset_counter>
    synt_set_reload(HPM_SYNT, reload);
80008232:	012007b7          	lui	a5,0x1200
80008236:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
8000823a:	85be                	mv	a1,a5
8000823c:	f0464537          	lui	a0,0xf0464
80008240:	d34fc0ef          	jal	80004774 <synt_set_reload>
    synt_set_comparator(HPM_SYNT, SYNT_CMP_0, (reload >> 3));
80008244:	012007b7          	lui	a5,0x1200
80008248:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
8000824c:	838d                	srli	a5,a5,0x3
8000824e:	863e                	mv	a2,a5
80008250:	4581                	li	a1,0
80008252:	f0464537          	lui	a0,0xf0464
80008256:	cecfc0ef          	jal	80004742 <synt_set_comparator>
    synt_set_comparator(HPM_SYNT, SYNT_CMP_1, (reload >> 2));
8000825a:	012007b7          	lui	a5,0x1200
8000825e:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
80008262:	8389                	srli	a5,a5,0x2
80008264:	863e                	mv	a2,a5
80008266:	4585                	li	a1,1
80008268:	f0464537          	lui	a0,0xf0464
8000826c:	cd6fc0ef          	jal	80004742 <synt_set_comparator>
    synt_set_comparator(HPM_SYNT, SYNT_CMP_2, (reload >> 1));
80008270:	012007b7          	lui	a5,0x1200
80008274:	01c7a783          	lw	a5,28(a5) # 120001c <reload>
80008278:	8385                	srli	a5,a5,0x1
8000827a:	863e                	mv	a2,a5
8000827c:	4589                	li	a1,2
8000827e:	f0464537          	lui	a0,0xf0464
80008282:	cc0fc0ef          	jal	80004742 <synt_set_comparator>
}
80008286:	0001                	nop
80008288:	40b2                	lw	ra,12(sp)
8000828a:	0141                	addi	sp,sp,16
8000828c:	8082                	ret

Disassembly of section .text.pwm_start_same_time:

8000828e <pwm_start_same_time>:
{
8000828e:	1141                	addi	sp,sp,-16
80008290:	c606                	sw	ra,12(sp)
    init_start_trgm_connect();
80008292:	d84fc0ef          	jal	80004816 <init_start_trgm_connect>
    pwm_sync_three_submodules_handware_config();
80008296:	decfc0ef          	jal	80004882 <pwm_sync_three_submodules_handware_config>
    board_delay_ms(2000);
8000829a:	7d000513          	li	a0,2000
8000829e:	039000ef          	jal	80008ad6 <board_delay_ms>
    sync_start();
800082a2:	d60fc0ef          	jal	80004802 <sync_start>
}
800082a6:	0001                	nop
800082a8:	40b2                	lw	ra,12(sp)
800082aa:	0141                	addi	sp,sp,16
800082ac:	8082                	ret

Disassembly of section .text.init_trigger_target:

800082ae <init_trigger_target>:
{
800082ae:	7179                	addi	sp,sp,-48
800082b0:	d606                	sw	ra,44(sp)
800082b2:	c62a                	sw	a0,12(sp)
800082b4:	87ae                	mv	a5,a1
800082b6:	00f105a3          	sb	a5,11(sp)
    pmt_cfg.trig_len = sizeof(trig_adc_channel);
800082ba:	478d                	li	a5,3
800082bc:	00f10ca3          	sb	a5,25(sp)
    pmt_cfg.trig_ch = trig_ch;
800082c0:	00b14783          	lbu	a5,11(sp)
800082c4:	00f10c23          	sb	a5,24(sp)

800082c8 <.LBB22>:
    for (int i = 0; i < pmt_cfg.trig_len; i++) {
800082c8:	ce02                	sw	zero,28(sp)
800082ca:	a805                	j	800082fa <.L68>

800082cc <.L69>:
        pmt_cfg.adc_ch[i] = trig_adc_channel[i];
800082cc:	012007b7          	lui	a5,0x1200
800082d0:	05c78713          	addi	a4,a5,92 # 120005c <trig_adc_channel>
800082d4:	47f2                	lw	a5,28(sp)
800082d6:	97ba                	add	a5,a5,a4
800082d8:	0007c703          	lbu	a4,0(a5)
800082dc:	47f2                	lw	a5,28(sp)
800082de:	02078793          	addi	a5,a5,32
800082e2:	978a                	add	a5,a5,sp
800082e4:	fee78a23          	sb	a4,-12(a5)
        pmt_cfg.inten[i] = false;
800082e8:	47f2                	lw	a5,28(sp)
800082ea:	02078793          	addi	a5,a5,32
800082ee:	978a                	add	a5,a5,sp
800082f0:	fe078823          	sb	zero,-16(a5)
    for (int i = 0; i < pmt_cfg.trig_len; i++) {
800082f4:	47f2                	lw	a5,28(sp)
800082f6:	0785                	addi	a5,a5,1
800082f8:	ce3e                	sw	a5,28(sp)

800082fa <.L68>:
800082fa:	01914783          	lbu	a5,25(sp)
800082fe:	873e                	mv	a4,a5
80008300:	47f2                	lw	a5,28(sp)
80008302:	fce7c5e3          	blt	a5,a4,800082cc <.L69>

80008306 <.LBE22>:
    pmt_cfg.inten[pmt_cfg.trig_len - 1] = true;
80008306:	01914783          	lbu	a5,25(sp)
8000830a:	17fd                	addi	a5,a5,-1
8000830c:	02078793          	addi	a5,a5,32
80008310:	978a                	add	a5,a5,sp
80008312:	4705                	li	a4,1
80008314:	fee78823          	sb	a4,-16(a5)
    adc16_set_pmt_config(ptr, &pmt_cfg);
80008318:	081c                	addi	a5,sp,16
8000831a:	85be                	mv	a1,a5
8000831c:	4532                	lw	a0,12(sp)
8000831e:	12f010ef          	jal	80009c4c <adc16_set_pmt_config>
    adc16_enable_pmt_queue(ptr, trig_ch);
80008322:	00b14783          	lbu	a5,11(sp)
80008326:	85be                	mv	a1,a5
80008328:	4532                	lw	a0,12(sp)
8000832a:	1d3010ef          	jal	80009cfc <adc16_enable_pmt_queue>
}
8000832e:	0001                	nop
80008330:	50b2                	lw	ra,44(sp)
80008332:	6145                	addi	sp,sp,48
80008334:	8082                	ret

Disassembly of section .text.gpio_input_interrupt:

80008336 <gpio_input_interrupt>:
{
80008336:	715d                	addi	sp,sp,-80
80008338:	c686                	sw	ra,76(sp)
    gpio_set_pin_input(BOARD_KEYA_GPIO_CTRL, BOARD_KEYA_GPIO_INDEX,
8000833a:	4621                	li	a2,8
8000833c:	4589                	li	a1,2
8000833e:	f00d0537          	lui	a0,0xf00d0
80008342:	3585                	jal	800081a2 <gpio_set_pin_input>
    gpio_set_pin_input(BOARD_KEYB_GPIO_CTRL, BOARD_KEYB_GPIO_INDEX,
80008344:	4641                	li	a2,16
80008346:	4589                	li	a1,2
80008348:	f00d0537          	lui	a0,0xf00d0
8000834c:	3d99                	jal	800081a2 <gpio_set_pin_input>
    trigger = gpio_interrupt_trigger_edge_rising;
8000834e:	4789                	li	a5,2
80008350:	02f10fa3          	sb	a5,63(sp)
    gpio_config_pin_interrupt(BOARD_KEYA_GPIO_CTRL, BOARD_KEYA_GPIO_INDEX,
80008354:	03f14783          	lbu	a5,63(sp)
80008358:	86be                	mv	a3,a5
8000835a:	4621                	li	a2,8
8000835c:	4589                	li	a1,2
8000835e:	f00d0537          	lui	a0,0xf00d0
80008362:	fd9fd0ef          	jal	8000633a <gpio_config_pin_interrupt>
    gpio_enable_pin_interrupt(BOARD_KEYA_GPIO_CTRL, BOARD_KEYA_GPIO_INDEX,
80008366:	4621                	li	a2,8
80008368:	4589                	li	a1,2
8000836a:	f00d0537          	lui	a0,0xf00d0
8000836e:	3571                	jal	800081fa <gpio_enable_pin_interrupt>
    gpio_config_pin_interrupt(BOARD_KEYB_GPIO_CTRL, BOARD_KEYB_GPIO_INDEX,
80008370:	03f14783          	lbu	a5,63(sp)
80008374:	86be                	mv	a3,a5
80008376:	4621                	li	a2,8
80008378:	4589                	li	a1,2
8000837a:	f00d0537          	lui	a0,0xf00d0
8000837e:	fbdfd0ef          	jal	8000633a <gpio_config_pin_interrupt>
    gpio_enable_pin_interrupt(BOARD_KEYB_GPIO_CTRL, BOARD_KEYB_GPIO_INDEX,
80008382:	4641                	li	a2,16
80008384:	4589                	li	a1,2
80008386:	f00d0537          	lui	a0,0xf00d0
8000838a:	3d85                	jal	800081fa <gpio_enable_pin_interrupt>
8000838c:	478d                	li	a5,3
8000838e:	ce3e                	sw	a5,28(sp)
80008390:	4785                	li	a5,1
80008392:	cc3e                	sw	a5,24(sp)
80008394:	e40007b7          	lui	a5,0xe4000
80008398:	ca3e                	sw	a5,20(sp)
8000839a:	47f2                	lw	a5,28(sp)
8000839c:	c83e                	sw	a5,16(sp)
8000839e:	47e2                	lw	a5,24(sp)
800083a0:	c63e                	sw	a5,12(sp)

800083a2 <.LBB33>:
            HPM_PLIC_PRIORITY_OFFSET + ((irq-1) << HPM_PLIC_PRIORITY_SHIFT_PER_SOURCE));
800083a2:	47c2                	lw	a5,16(sp)
800083a4:	17fd                	addi	a5,a5,-1 # e3ffffff <__FLASH_segment_end__+0x63efffff>
800083a6:	00279713          	slli	a4,a5,0x2
800083aa:	47d2                	lw	a5,20(sp)
800083ac:	97ba                	add	a5,a5,a4
800083ae:	0791                	addi	a5,a5,4
    volatile uint32_t *priority_ptr = (volatile uint32_t *)(base +
800083b0:	c43e                	sw	a5,8(sp)
    *priority_ptr = priority;
800083b2:	47a2                	lw	a5,8(sp)
800083b4:	4732                	lw	a4,12(sp)
800083b6:	c398                	sw	a4,0(a5)
}
800083b8:	0001                	nop

800083ba <.LBE35>:
}
800083ba:	0001                	nop
800083bc:	dc02                	sw	zero,56(sp)
800083be:	478d                	li	a5,3
800083c0:	da3e                	sw	a5,52(sp)
800083c2:	e40007b7          	lui	a5,0xe4000
800083c6:	d83e                	sw	a5,48(sp)
800083c8:	57e2                	lw	a5,56(sp)
800083ca:	d63e                	sw	a5,44(sp)
800083cc:	57d2                	lw	a5,52(sp)
800083ce:	d43e                	sw	a5,40(sp)

800083d0 <.LBB37>:
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
800083d0:	57b2                	lw	a5,44(sp)
800083d2:	00779713          	slli	a4,a5,0x7
            HPM_PLIC_ENABLE_OFFSET +
800083d6:	57c2                	lw	a5,48(sp)
800083d8:	973e                	add	a4,a4,a5
            ((irq >> 5) << 2));
800083da:	57a2                	lw	a5,40(sp)
800083dc:	8395                	srli	a5,a5,0x5
800083de:	078a                	slli	a5,a5,0x2
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
800083e0:	973e                	add	a4,a4,a5
800083e2:	6789                	lui	a5,0x2
800083e4:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
800083e6:	d23e                	sw	a5,36(sp)
    uint32_t current = *current_ptr;
800083e8:	5792                	lw	a5,36(sp)
800083ea:	439c                	lw	a5,0(a5)
800083ec:	d03e                	sw	a5,32(sp)
    current = current | (1 << (irq & 0x1F));
800083ee:	57a2                	lw	a5,40(sp)
800083f0:	8bfd                	andi	a5,a5,31
800083f2:	4705                	li	a4,1
800083f4:	00f717b3          	sll	a5,a4,a5
800083f8:	873e                	mv	a4,a5
800083fa:	5782                	lw	a5,32(sp)
800083fc:	8fd9                	or	a5,a5,a4
800083fe:	d03e                	sw	a5,32(sp)
    *current_ptr = current;
80008400:	5792                	lw	a5,36(sp)
80008402:	5702                	lw	a4,32(sp)
80008404:	c398                	sw	a4,0(a5)
}
80008406:	0001                	nop

80008408 <.LBE39>:
}
80008408:	0001                	nop

8000840a <.LBE37>:
}
8000840a:	0001                	nop
8000840c:	40b6                	lw	ra,76(sp)
8000840e:	6161                	addi	sp,sp,80
80008410:	8082                	ret

Disassembly of section .text.main:

80008412 <main>:
{
80008412:	1101                	addi	sp,sp,-32
80008414:	ce06                	sw	ra,28(sp)
    board_init();
80008416:	255d                	jal	80008abc <board_init>
    board_init_gpio_pins();
80008418:	2dc9                	jal	80008aea <board_init_gpio_pins>
    init_pwm_pins(PWM);
8000841a:	f0420537          	lui	a0,0xf0420
8000841e:	29cd                	jal	80008910 <init_pwm_pins>
    board_init_adc16_pins();
80008420:	235000ef          	jal	80008e54 <board_init_adc16_pins>
    board_init_adc_clock(BOARD_APP_ADC16_BASE, true);
80008424:	4585                	li	a1,1
80008426:	f0100537          	lui	a0,0xf0100
8000842a:	9bbfd0ef          	jal	80005de4 <board_init_adc_clock>
    gpio_input_interrupt();
8000842e:	3721                	jal	80008336 <gpio_input_interrupt>
    init_common_config(adc16_conv_mode_preemption);
80008430:	450d                	li	a0,3
80008432:	f4efc0ef          	jal	80004b80 <init_common_config>
    init_preemption_config();
80008436:	859fc0ef          	jal	80004c8e <init_preemption_config>
    printf("pwmv2 three pwm submodule synchronous example\n");
8000843a:	8b818513          	addi	a0,gp,-1864 # 800039ec <.LC12>
8000843e:	ccdfe0ef          	jal	8000710a <printf>
    printf("choose PWM output channel [P%d P%d P%d]\n", PWM_OUTPUT_PIN1, PWM_OUTPUT_PIN2, PWM_OUTPUT_PIN3);
80008442:	4689                	li	a3,2
80008444:	4605                	li	a2,1
80008446:	4581                	li	a1,0
80008448:	8e818513          	addi	a0,gp,-1816 # 80003a1c <.LC13>
8000844c:	cbffe0ef          	jal	8000710a <printf>
    freq = clock_get_frequency(PWM_CLOCK_NAME);
80008450:	013507b7          	lui	a5,0x1350
80008454:	30078513          	addi	a0,a5,768 # 1350300 <__NONCACHEABLE_RAM_segment_end__+0x110300>
80008458:	b0afd0ef          	jal	80005762 <clock_get_frequency>
8000845c:	872a                	mv	a4,a0
8000845e:	012007b7          	lui	a5,0x1200
80008462:	02e7aa23          	sw	a4,52(a5) # 1200034 <freq>
    reload = freq / 10000;//1000 * PWM_PERIOD_IN_MS;
80008466:	012007b7          	lui	a5,0x1200
8000846a:	0347a703          	lw	a4,52(a5) # 1200034 <freq>
8000846e:	d1b717b7          	lui	a5,0xd1b71
80008472:	75978793          	addi	a5,a5,1881 # d1b71759 <__FLASH_segment_end__+0x51a71759>
80008476:	02f737b3          	mulhu	a5,a4,a5
8000847a:	00d7d713          	srli	a4,a5,0xd
8000847e:	012007b7          	lui	a5,0x1200
80008482:	00e7ae23          	sw	a4,28(a5) # 120001c <reload>
    init_synt_timebase();
80008486:	3345                	jal	80008226 <init_synt_timebase>
    pwm_fault_async();
80008488:	afefc0ef          	jal	80004786 <pwm_fault_async>
    printf("\n\n>> P%d P%d P%d generate waveform at same time\n", PWM_OUTPUT_PIN1, PWM_OUTPUT_PIN2, PWM_OUTPUT_PIN3);
8000848c:	4689                	li	a3,2
8000848e:	4605                	li	a2,1
80008490:	4581                	li	a1,0
80008492:	91418513          	addi	a0,gp,-1772 # 80003a48 <.LC14>
80008496:	c75fe0ef          	jal	8000710a <printf>
    printf("P%d is a reference\n", PWM_OUTPUT_PIN1);
8000849a:	4581                	li	a1,0
8000849c:	94818513          	addi	a0,gp,-1720 # 80003a7c <.LC15>
800084a0:	c6bfe0ef          	jal	8000710a <printf>
    pwm_start_same_time();
800084a4:	33ed                	jal	8000828e <pwm_start_same_time>

800084a6 <.L93>:
    adc16_pmt_dma_data_t *dma_data = (adc16_pmt_dma_data_t *)pmt_buff;
800084a6:	012317b7          	lui	a5,0x1231
800084aa:	00078793          	mv	a5,a5
800084ae:	c63e                	sw	a5,12(sp)
    printf("%d,%d,%d\n",dma_data[0].result,dma_data[1].result,dma_data[2].result);
800084b0:	47b2                	lw	a5,12(sp)
800084b2:	0007d783          	lhu	a5,0(a5) # 1231000 <pmt_buff>
800084b6:	873e                	mv	a4,a5
800084b8:	47b2                	lw	a5,12(sp)
800084ba:	0791                	addi	a5,a5,4
800084bc:	0007d783          	lhu	a5,0(a5)
800084c0:	863e                	mv	a2,a5
800084c2:	47b2                	lw	a5,12(sp)
800084c4:	07a1                	addi	a5,a5,8
800084c6:	0007d783          	lhu	a5,0(a5)
800084ca:	86be                	mv	a3,a5
800084cc:	85ba                	mv	a1,a4
800084ce:	95c18513          	addi	a0,gp,-1700 # 80003a90 <.LC16>
800084d2:	c39fe0ef          	jal	8000710a <printf>
    board_delay_ms(1);
800084d6:	4505                	li	a0,1
800084d8:	2bfd                	jal	80008ad6 <board_delay_ms>

800084da <.LBE41>:
    while (1) {
800084da:	b7f1                	j	800084a6 <.L93>

Disassembly of section .text.cos_f32:

800084dc <cos_f32>:
{
800084dc:	7139                	addi	sp,sp,-64
800084de:	de06                	sw	ra,60(sp)
800084e0:	dc22                	sw	s0,56(sp)
800084e2:	c62a                	sw	a0,12(sp)
    in = x * 0.159154943092f + 0.25f;
800084e4:	9741a583          	lw	a1,-1676(gp) # 80003aa8 <.LC17>
800084e8:	4532                	lw	a0,12(sp)
800084ea:	307010ef          	jal	80009ff0 <__mulsf3>
800084ee:	87aa                	mv	a5,a0
800084f0:	873e                	mv	a4,a5
800084f2:	9801a583          	lw	a1,-1664(gp) # 80003ab4 <.LC20>
800084f6:	853a                	mv	a0,a4
800084f8:	b2efe0ef          	jal	80006826 <__addsf3>
800084fc:	87aa                	mv	a5,a0
800084fe:	d03e                	sw	a5,32(sp)
    n = (int32_t) in;
80008500:	5502                	lw	a0,32(sp)
80008502:	db2fe0ef          	jal	80006ab4 <__fixsfsi>
80008506:	87aa                	mv	a5,a0
80008508:	d43e                	sw	a5,40(sp)
    if (in < 0.0f) {
8000850a:	00000593          	li	a1,0
8000850e:	5502                	lw	a0,32(sp)
80008510:	cc4fe0ef          	jal	800069d4 <__ltsf2>
80008514:	87aa                	mv	a5,a0
80008516:	0007d563          	bgez	a5,80008520 <.L101>
        n--;
8000851a:	57a2                	lw	a5,40(sp)
8000851c:	17fd                	addi	a5,a5,-1
8000851e:	d43e                	sw	a5,40(sp)

80008520 <.L101>:
    in = in - (float) n;
80008520:	5522                	lw	a0,40(sp)
80008522:	e0efe0ef          	jal	80006b30 <__floatsisf>
80008526:	87aa                	mv	a5,a0
80008528:	85be                	mv	a1,a5
8000852a:	5502                	lw	a0,32(sp)
8000852c:	af2fe0ef          	jal	8000681e <__subsf3>
80008530:	87aa                	mv	a5,a0
80008532:	d03e                	sw	a5,32(sp)
    findex = (float) SIN_TABLE_SIZE * in;
80008534:	9781a583          	lw	a1,-1672(gp) # 80003aac <.LC18>
80008538:	5502                	lw	a0,32(sp)
8000853a:	2b7010ef          	jal	80009ff0 <__mulsf3>
8000853e:	87aa                	mv	a5,a0
80008540:	d23e                	sw	a5,36(sp)
    index  = (uint16_t) findex;
80008542:	5512                	lw	a0,36(sp)
80008544:	dbafe0ef          	jal	80006afe <__fixunssfsi>
80008548:	87aa                	mv	a5,a0
8000854a:	02f11723          	sh	a5,46(sp)
    if (index >= SIN_TABLE_SIZE) {
8000854e:	02e15703          	lhu	a4,46(sp)
80008552:	1ff00793          	li	a5,511
80008556:	00e7fb63          	bgeu	a5,a4,8000856c <.L103>
        index = 0;
8000855a:	02011723          	sh	zero,46(sp)
        findex -= (float) SIN_TABLE_SIZE;
8000855e:	9781a583          	lw	a1,-1672(gp) # 80003aac <.LC18>
80008562:	5512                	lw	a0,36(sp)
80008564:	abafe0ef          	jal	8000681e <__subsf3>
80008568:	87aa                	mv	a5,a0
8000856a:	d23e                	sw	a5,36(sp)

8000856c <.L103>:
    fract = findex - (float) index;
8000856c:	02e15783          	lhu	a5,46(sp)
80008570:	853e                	mv	a0,a5
80008572:	e24fe0ef          	jal	80006b96 <__floatunsisf>
80008576:	87aa                	mv	a5,a0
80008578:	85be                	mv	a1,a5
8000857a:	5512                	lw	a0,36(sp)
8000857c:	aa2fe0ef          	jal	8000681e <__subsf3>
80008580:	87aa                	mv	a5,a0
80008582:	ce3e                	sw	a5,28(sp)
    a = sinTable_f32[index];
80008584:	02e15783          	lhu	a5,46(sp)
80008588:	80003737          	lui	a4,0x80003
8000858c:	10870713          	addi	a4,a4,264 # 80003108 <sinTable_f32>
80008590:	078a                	slli	a5,a5,0x2
80008592:	97ba                	add	a5,a5,a4
80008594:	439c                	lw	a5,0(a5)
80008596:	cc3e                	sw	a5,24(sp)
    b = sinTable_f32[index + 1];
80008598:	02e15783          	lhu	a5,46(sp)
8000859c:	0785                	addi	a5,a5,1
8000859e:	80003737          	lui	a4,0x80003
800085a2:	10870713          	addi	a4,a4,264 # 80003108 <sinTable_f32>
800085a6:	078a                	slli	a5,a5,0x2
800085a8:	97ba                	add	a5,a5,a4
800085aa:	439c                	lw	a5,0(a5)
800085ac:	ca3e                	sw	a5,20(sp)
    cosVal = (1.0f - fract) * a + fract * b;
800085ae:	45f2                	lw	a1,28(sp)
800085b0:	97c1a503          	lw	a0,-1668(gp) # 80003ab0 <.LC19>
800085b4:	a6afe0ef          	jal	8000681e <__subsf3>
800085b8:	87aa                	mv	a5,a0
800085ba:	45e2                	lw	a1,24(sp)
800085bc:	853e                	mv	a0,a5
800085be:	233010ef          	jal	80009ff0 <__mulsf3>
800085c2:	87aa                	mv	a5,a0
800085c4:	843e                	mv	s0,a5
800085c6:	45d2                	lw	a1,20(sp)
800085c8:	4572                	lw	a0,28(sp)
800085ca:	227010ef          	jal	80009ff0 <__mulsf3>
800085ce:	87aa                	mv	a5,a0
800085d0:	85be                	mv	a1,a5
800085d2:	8522                	mv	a0,s0
800085d4:	a52fe0ef          	jal	80006826 <__addsf3>
800085d8:	87aa                	mv	a5,a0
800085da:	c83e                	sw	a5,16(sp)
    return (cosVal);
800085dc:	47c2                	lw	a5,16(sp)
}
800085de:	853e                	mv	a0,a5
800085e0:	50f2                	lw	ra,60(sp)
800085e2:	5462                	lw	s0,56(sp)
800085e4:	6121                	addi	sp,sp,64
800085e6:	8082                	ret

Disassembly of section .text.reset_handler:

800085e8 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
800085e8:	1141                	addi	sp,sp,-16
800085ea:	c606                	sw	ra,12(sp)
    fencei();
800085ec:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
800085f0:	febfc0ef          	jal	800055da <system_init>

    /* Entry function */
    MAIN_ENTRY();
800085f4:	3d39                	jal	80008412 <main>
}
800085f6:	0001                	nop
800085f8:	40b2                	lw	ra,12(sp)
800085fa:	0141                	addi	sp,sp,16
800085fc:	8082                	ret

Disassembly of section .text._init:

800085fe <_init>:
void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
800085fe:	0001                	nop
80008600:	8082                	ret

Disassembly of section .text.mchtmr_isr:

80008602 <mchtmr_isr>:
}
80008602:	0001                	nop
80008604:	8082                	ret

Disassembly of section .text.swi_isr:

80008606 <swi_isr>:
}
80008606:	0001                	nop
80008608:	8082                	ret

Disassembly of section .text.exception_handler:

8000860a <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
8000860a:	1141                	addi	sp,sp,-16
8000860c:	c62a                	sw	a0,12(sp)
8000860e:	c42e                	sw	a1,8(sp)
    switch (cause) {
80008610:	4732                	lw	a4,12(sp)
80008612:	47bd                	li	a5,15
80008614:	00e7ea63          	bltu	a5,a4,80008628 <.L23>
80008618:	47b2                	lw	a5,12(sp)
8000861a:	00279713          	slli	a4,a5,0x2
8000861e:	9bc18793          	addi	a5,gp,-1604 # 80003af0 <.L7>
80008622:	97ba                	add	a5,a5,a4
80008624:	439c                	lw	a5,0(a5)
80008626:	8782                	jr	a5

80008628 <.L23>:
    case MCAUSE_LOAD_PAGE_FAULT:
        break;
    case MCAUSE_STORE_AMO_PAGE_FAULT:
        break;
    default:
        break;
80008628:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
8000862a:	47a2                	lw	a5,8(sp)
}
8000862c:	853e                	mv	a0,a5
8000862e:	0141                	addi	sp,sp,16
80008630:	8082                	ret

Disassembly of section .text.enable_plic_feature:

80008632 <enable_plic_feature>:
{
80008632:	1141                	addi	sp,sp,-16
    uint32_t plic_feature = 0;
80008634:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
80008636:	47b2                	lw	a5,12(sp)
80008638:	0027e793          	ori	a5,a5,2
8000863c:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
8000863e:	47b2                	lw	a5,12(sp)
80008640:	0017e793          	ori	a5,a5,1
80008644:	c63e                	sw	a5,12(sp)
80008646:	e40007b7          	lui	a5,0xe4000
8000864a:	c43e                	sw	a5,8(sp)
8000864c:	47b2                	lw	a5,12(sp)
8000864e:	c23e                	sw	a5,4(sp)

80008650 <.LBB14>:
    *(volatile uint32_t *)(base + HPM_PLIC_FEATURE_OFFSET) = feature;
80008650:	47a2                	lw	a5,8(sp)
80008652:	4712                	lw	a4,4(sp)
80008654:	c398                	sw	a4,0(a5)
}
80008656:	0001                	nop

80008658 <.LBE14>:
}
80008658:	0001                	nop
8000865a:	0141                	addi	sp,sp,16
8000865c:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

8000865e <sysctl_clock_target_is_busy>:
{
8000865e:	1141                	addi	sp,sp,-16
80008660:	c62a                	sw	a0,12(sp)
80008662:	c42e                	sw	a1,8(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
80008664:	4732                	lw	a4,12(sp)
80008666:	47a2                	lw	a5,8(sp)
80008668:	60078793          	addi	a5,a5,1536 # e4000600 <__FLASH_segment_end__+0x63f00600>
8000866c:	078a                	slli	a5,a5,0x2
8000866e:	97ba                	add	a5,a5,a4
80008670:	4398                	lw	a4,0(a5)
80008672:	400007b7          	lui	a5,0x40000
80008676:	8ff9                	and	a5,a5,a4
80008678:	00f037b3          	snez	a5,a5
8000867c:	0ff7f793          	zext.b	a5,a5
}
80008680:	853e                	mv	a0,a5
80008682:	0141                	addi	sp,sp,16
80008684:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

80008686 <sysctl_enable_group_resource>:
{
80008686:	7179                	addi	sp,sp,-48
80008688:	d606                	sw	ra,44(sp)
8000868a:	c62a                	sw	a0,12(sp)
8000868c:	87ae                	mv	a5,a1
8000868e:	8736                	mv	a4,a3
80008690:	00f105a3          	sb	a5,11(sp)
80008694:	87b2                	mv	a5,a2
80008696:	00f11423          	sh	a5,8(sp)
8000869a:	87ba                	mv	a5,a4
8000869c:	00f10523          	sb	a5,10(sp)
    if (linkable_resource < sysctl_resource_linkable_start) {
800086a0:	00815703          	lhu	a4,8(sp)
800086a4:	0ff00793          	li	a5,255
800086a8:	00e7e463          	bltu	a5,a4,800086b0 <.L50>
        return status_invalid_argument;
800086ac:	4789                	li	a5,2
800086ae:	a851                	j	80008742 <.L51>

800086b0 <.L50>:
    index = (linkable_resource - sysctl_resource_linkable_start) / 32;
800086b0:	00815783          	lhu	a5,8(sp)
800086b4:	f0078793          	addi	a5,a5,-256 # 3fffff00 <__NONCACHEABLE_RAM_segment_end__+0x3edbff00>
800086b8:	41f7d713          	srai	a4,a5,0x1f
800086bc:	8b7d                	andi	a4,a4,31
800086be:	97ba                	add	a5,a5,a4
800086c0:	8795                	srai	a5,a5,0x5
800086c2:	ce3e                	sw	a5,28(sp)
    offset = (linkable_resource - sysctl_resource_linkable_start) % 32;
800086c4:	00815783          	lhu	a5,8(sp)
800086c8:	f0078713          	addi	a4,a5,-256
800086cc:	41f75793          	srai	a5,a4,0x1f
800086d0:	83ed                	srli	a5,a5,0x1b
800086d2:	973e                	add	a4,a4,a5
800086d4:	8b7d                	andi	a4,a4,31
800086d6:	40f707b3          	sub	a5,a4,a5
800086da:	cc3e                	sw	a5,24(sp)
    switch (group) {
800086dc:	00b14783          	lbu	a5,11(sp)
800086e0:	efa9                	bnez	a5,8000873a <.L52>
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset)) | (enable ? (1UL << offset) : 0);
800086e2:	4732                	lw	a4,12(sp)
800086e4:	47f2                	lw	a5,28(sp)
800086e6:	08078793          	addi	a5,a5,128
800086ea:	0792                	slli	a5,a5,0x4
800086ec:	97ba                	add	a5,a5,a4
800086ee:	4398                	lw	a4,0(a5)
800086f0:	47e2                	lw	a5,24(sp)
800086f2:	4685                	li	a3,1
800086f4:	00f697b3          	sll	a5,a3,a5
800086f8:	fff7c793          	not	a5,a5
800086fc:	8f7d                	and	a4,a4,a5
800086fe:	00a14783          	lbu	a5,10(sp)
80008702:	c791                	beqz	a5,8000870e <.L53>
80008704:	47e2                	lw	a5,24(sp)
80008706:	4685                	li	a3,1
80008708:	00f697b3          	sll	a5,a3,a5
8000870c:	a011                	j	80008710 <.L54>

8000870e <.L53>:
8000870e:	4781                	li	a5,0

80008710 <.L54>:
80008710:	8f5d                	or	a4,a4,a5
80008712:	46b2                	lw	a3,12(sp)
80008714:	47f2                	lw	a5,28(sp)
80008716:	08078793          	addi	a5,a5,128
8000871a:	0792                	slli	a5,a5,0x4
8000871c:	97b6                	add	a5,a5,a3
8000871e:	c398                	sw	a4,0(a5)
        if (enable) {
80008720:	00a14783          	lbu	a5,10(sp)
80008724:	cf89                	beqz	a5,8000873e <.L58>
            while (sysctl_resource_target_is_busy(ptr, linkable_resource)) {
80008726:	0001                	nop

80008728 <.L56>:
80008728:	00815783          	lhu	a5,8(sp)
8000872c:	85be                	mv	a1,a5
8000872e:	4532                	lw	a0,12(sp)
80008730:	f01fc0ef          	jal	80005630 <sysctl_resource_target_is_busy>
80008734:	87aa                	mv	a5,a0
80008736:	fbed                	bnez	a5,80008728 <.L56>
        break;
80008738:	a019                	j	8000873e <.L58>

8000873a <.L52>:
        return status_invalid_argument;
8000873a:	4789                	li	a5,2
8000873c:	a019                	j	80008742 <.L51>

8000873e <.L58>:
        break;
8000873e:	0001                	nop
    return status_success;
80008740:	4781                	li	a5,0

80008742 <.L51>:
}
80008742:	853e                	mv	a0,a5
80008744:	50b2                	lw	ra,44(sp)
80008746:	6145                	addi	sp,sp,48
80008748:	8082                	ret

Disassembly of section .text.get_frequency_for_adc:

8000874a <get_frequency_for_adc>:
{
8000874a:	7179                	addi	sp,sp,-48
8000874c:	d606                	sw	ra,44(sp)
8000874e:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
80008750:	ce02                	sw	zero,28(sp)
    bool is_mux_valid = false;
80008752:	00010da3          	sb	zero,27(sp)
    clock_node_t node = clock_node_end;
80008756:	02b00793          	li	a5,43
8000875a:	00f10d23          	sb	a5,26(sp)
    if (instance < ADC_INSTANCE_NUM) {
8000875e:	4732                	lw	a4,12(sp)
80008760:	4785                	li	a5,1
80008762:	02e7ee63          	bltu	a5,a4,8000879e <.L48>

80008766 <.LBB7>:
        uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[instance]);
80008766:	f4000737          	lui	a4,0xf4000
8000876a:	47b2                	lw	a5,12(sp)
8000876c:	70078793          	addi	a5,a5,1792
80008770:	078a                	slli	a5,a5,0x2
80008772:	97ba                	add	a5,a5,a4
80008774:	439c                	lw	a5,0(a5)
80008776:	83a1                	srli	a5,a5,0x8
80008778:	8b85                	andi	a5,a5,1
8000877a:	ca3e                	sw	a5,20(sp)
        if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
8000877c:	4752                	lw	a4,20(sp)
8000877e:	4785                	li	a5,1
80008780:	00e7ef63          	bltu	a5,a4,8000879e <.L48>
            node = s_adc_clk_mux_node[mux_in_reg];
80008784:	800047b7          	lui	a5,0x80004
80008788:	f0478713          	addi	a4,a5,-252 # 80003f04 <s_adc_clk_mux_node>
8000878c:	47d2                	lw	a5,20(sp)
8000878e:	97ba                	add	a5,a5,a4
80008790:	0007c783          	lbu	a5,0(a5)
80008794:	00f10d23          	sb	a5,26(sp)
            is_mux_valid = true;
80008798:	4785                	li	a5,1
8000879a:	00f10da3          	sb	a5,27(sp)

8000879e <.L48>:
    if (is_mux_valid) {
8000879e:	01b14783          	lbu	a5,27(sp)
800087a2:	cb8d                	beqz	a5,800087d4 <.L49>
        if (node == clock_node_ahb0) {
800087a4:	01a14703          	lbu	a4,26(sp)
800087a8:	4789                	li	a5,2
800087aa:	00f71763          	bne	a4,a5,800087b8 <.L50>
            clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
800087ae:	4509                	li	a0,2
800087b0:	90cfd0ef          	jal	800058bc <get_frequency_for_ip_in_common_group>
800087b4:	ce2a                	sw	a0,28(sp)
800087b6:	a839                	j	800087d4 <.L49>

800087b8 <.L50>:
            node += instance;
800087b8:	47b2                	lw	a5,12(sp)
800087ba:	0ff7f793          	zext.b	a5,a5
800087be:	01a14703          	lbu	a4,26(sp)
800087c2:	97ba                	add	a5,a5,a4
800087c4:	00f10d23          	sb	a5,26(sp)
            clk_freq = get_frequency_for_ip_in_common_group(node);
800087c8:	01a14783          	lbu	a5,26(sp)
800087cc:	853e                	mv	a0,a5
800087ce:	8eefd0ef          	jal	800058bc <get_frequency_for_ip_in_common_group>
800087d2:	ce2a                	sw	a0,28(sp)

800087d4 <.L49>:
    return clk_freq;
800087d4:	47f2                	lw	a5,28(sp)
}
800087d6:	853e                	mv	a0,a5
800087d8:	50b2                	lw	ra,44(sp)
800087da:	6145                	addi	sp,sp,48
800087dc:	8082                	ret

Disassembly of section .text.get_frequency_for_ewdg:

800087de <get_frequency_for_ewdg>:
{
800087de:	7179                	addi	sp,sp,-48
800087e0:	d606                	sw	ra,44(sp)
800087e2:	c62a                	sw	a0,12(sp)
    if (EWDG_CTRL0_CLK_SEL_GET(s_wdgs[instance]->CTRL0) == 0) {
800087e4:	9fc18713          	addi	a4,gp,-1540 # 80003b30 <s_wdgs>
800087e8:	47b2                	lw	a5,12(sp)
800087ea:	078a                	slli	a5,a5,0x2
800087ec:	97ba                	add	a5,a5,a4
800087ee:	439c                	lw	a5,0(a5)
800087f0:	4398                	lw	a4,0(a5)
800087f2:	200007b7          	lui	a5,0x20000
800087f6:	8ff9                	and	a5,a5,a4
800087f8:	e791                	bnez	a5,80008804 <.L53>
        freq_in_hz = get_frequency_for_ip_in_common_group(clock_node_ahb0);
800087fa:	4509                	li	a0,2
800087fc:	8c0fd0ef          	jal	800058bc <get_frequency_for_ip_in_common_group>
80008800:	ce2a                	sw	a0,28(sp)
80008802:	a019                	j	80008808 <.L54>

80008804 <.L53>:
        freq_in_hz = FREQ_32KHz;
80008804:	67a1                	lui	a5,0x8
80008806:	ce3e                	sw	a5,28(sp)

80008808 <.L54>:
    return freq_in_hz;
80008808:	47f2                	lw	a5,28(sp)
}
8000880a:	853e                	mv	a0,a5
8000880c:	50b2                	lw	ra,44(sp)
8000880e:	6145                	addi	sp,sp,48
80008810:	8082                	ret

Disassembly of section .text.get_frequency_for_pewdg:

80008812 <get_frequency_for_pewdg>:
{
80008812:	1141                	addi	sp,sp,-16
    if (EWDG_CTRL0_CLK_SEL_GET(HPM_PEWDG->CTRL0) == 0) {
80008814:	f41287b7          	lui	a5,0xf4128
80008818:	4398                	lw	a4,0(a5)
8000881a:	200007b7          	lui	a5,0x20000
8000881e:	8ff9                	and	a5,a5,a4
80008820:	e799                	bnez	a5,8000882e <.L57>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
80008822:	016e37b7          	lui	a5,0x16e3
80008826:	60078793          	addi	a5,a5,1536 # 16e3600 <__NONCACHEABLE_RAM_segment_end__+0x4a3600>
8000882a:	c63e                	sw	a5,12(sp)
8000882c:	a019                	j	80008832 <.L58>

8000882e <.L57>:
        freq_in_hz = FREQ_32KHz;
8000882e:	67a1                	lui	a5,0x8
80008830:	c63e                	sw	a5,12(sp)

80008832 <.L58>:
    return freq_in_hz;
80008832:	47b2                	lw	a5,12(sp)
}
80008834:	853e                	mv	a0,a5
80008836:	0141                	addi	sp,sp,16
80008838:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

8000883a <clock_connect_group_to_cpu>:
{
8000883a:	1141                	addi	sp,sp,-16
8000883c:	c62a                	sw	a0,12(sp)
8000883e:	c42e                	sw	a1,8(sp)
    if (cpu < 2U) {
80008840:	4722                	lw	a4,8(sp)
80008842:	4785                	li	a5,1
80008844:	00e7ee63          	bltu	a5,a4,80008860 <.L143>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
80008848:	f40006b7          	lui	a3,0xf4000
8000884c:	47b2                	lw	a5,12(sp)
8000884e:	4705                	li	a4,1
80008850:	00f71733          	sll	a4,a4,a5
80008854:	47a2                	lw	a5,8(sp)
80008856:	09078793          	addi	a5,a5,144 # 8090 <__AHB_SRAM_segment_size__+0x90>
8000885a:	0792                	slli	a5,a5,0x4
8000885c:	97b6                	add	a5,a5,a3
8000885e:	c3d8                	sw	a4,4(a5)

80008860 <.L143>:
}
80008860:	0001                	nop
80008862:	0141                	addi	sp,sp,16
80008864:	8082                	ret

Disassembly of section .text.clock_get_core_clock_ticks_per_ms:

80008866 <clock_get_core_clock_ticks_per_ms>:
{
80008866:	1141                	addi	sp,sp,-16
80008868:	c606                	sw	ra,12(sp)
    if (hpm_core_clock == 0U) {
8000886a:	012007b7          	lui	a5,0x1200
8000886e:	0247a783          	lw	a5,36(a5) # 1200024 <hpm_core_clock>
80008872:	e391                	bnez	a5,80008876 <.L151>
        clock_update_core_clock();
80008874:	2015                	jal	80008898 <.LFE153>

80008876 <.L151>:
    return (hpm_core_clock + FREQ_1KHz - 1U) / FREQ_1KHz;
80008876:	012007b7          	lui	a5,0x1200
8000887a:	0247a783          	lw	a5,36(a5) # 1200024 <hpm_core_clock>
8000887e:	3e778713          	addi	a4,a5,999
80008882:	106257b7          	lui	a5,0x10625
80008886:	dd378793          	addi	a5,a5,-557 # 10624dd3 <__NONCACHEABLE_RAM_segment_end__+0xf3e4dd3>
8000888a:	02f737b3          	mulhu	a5,a4,a5
8000888e:	8399                	srli	a5,a5,0x6
}
80008890:	853e                	mv	a0,a5
80008892:	40b2                	lw	ra,12(sp)
80008894:	0141                	addi	sp,sp,16
80008896:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

80008898 <clock_update_core_clock>:

void clock_update_core_clock(void)
{
80008898:	1141                	addi	sp,sp,-16
8000889a:	c606                	sw	ra,12(sp)
    hpm_core_clock = clock_get_frequency(clock_cpu0);
8000889c:	4501                	li	a0,0
8000889e:	ec5fc0ef          	jal	80005762 <clock_get_frequency>
800088a2:	872a                	mv	a4,a0
800088a4:	012007b7          	lui	a5,0x1200
800088a8:	02e7a223          	sw	a4,36(a5) # 1200024 <hpm_core_clock>
}
800088ac:	0001                	nop
800088ae:	40b2                	lw	ra,12(sp)
800088b0:	0141                	addi	sp,sp,16
800088b2:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

800088b4 <l1c_dc_invalidate_all>:
{
800088b4:	1141                	addi	sp,sp,-16
800088b6:	47dd                	li	a5,23
800088b8:	00f107a3          	sb	a5,15(sp)

800088bc <.LBB68>:
}

/* send command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
800088bc:	00f14783          	lbu	a5,15(sp)
800088c0:	7cc79073          	csrw	0x7cc,a5
}
800088c4:	0001                	nop

800088c6 <.LBE68>:
}
800088c6:	0001                	nop
800088c8:	0141                	addi	sp,sp,16
800088ca:	8082                	ret

Disassembly of section .text.init_uart_pins:

800088cc <init_uart_pins>:
{
800088cc:	1141                	addi	sp,sp,-16
800088ce:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
800088d0:	4732                	lw	a4,12(sp)
800088d2:	f00407b7          	lui	a5,0xf0040
800088d6:	00f71b63          	bne	a4,a5,800088ec <.L4>
        HPM_IOC->PAD[IOC_PAD_PA00].FUNC_CTL = IOC_PA00_FUNC_CTL_UART0_TXD;
800088da:	f40407b7          	lui	a5,0xf4040
800088de:	4709                	li	a4,2
800088e0:	c398                	sw	a4,0(a5)
        HPM_IOC->PAD[IOC_PAD_PA01].FUNC_CTL = IOC_PA01_FUNC_CTL_UART0_RXD;
800088e2:	f40407b7          	lui	a5,0xf4040
800088e6:	4709                	li	a4,2
800088e8:	c798                	sw	a4,8(a5)
}
800088ea:	a005                	j	8000890a <.L6>

800088ec <.L4>:
    } else if (ptr == HPM_UART3) {
800088ec:	4732                	lw	a4,12(sp)
800088ee:	f004c7b7          	lui	a5,0xf004c
800088f2:	00f71c63          	bne	a4,a5,8000890a <.L6>
        HPM_IOC->PAD[IOC_PAD_PC15].FUNC_CTL = IOC_PC15_FUNC_CTL_UART3_TXD;
800088f6:	f40407b7          	lui	a5,0xf4040
800088fa:	4709                	li	a4,2
800088fc:	26e7ac23          	sw	a4,632(a5) # f4040278 <__AHB_SRAM_segment_end__+0x3e38278>
        HPM_IOC->PAD[IOC_PAD_PC14].FUNC_CTL = IOC_PC14_FUNC_CTL_UART3_RXD;
80008900:	f40407b7          	lui	a5,0xf4040
80008904:	4709                	li	a4,2
80008906:	26e7a823          	sw	a4,624(a5) # f4040270 <__AHB_SRAM_segment_end__+0x3e38270>

8000890a <.L6>:
}
8000890a:	0001                	nop
8000890c:	0141                	addi	sp,sp,16
8000890e:	8082                	ret

Disassembly of section .text.init_pwm_pins:

80008910 <init_pwm_pins>:
{
    HPM_IOC->PAD[IOC_PAD_PC05].FUNC_CTL = IOC_PC05_FUNC_CTL_TRGM_P_05;
}

void init_pwm_pins(PWMV2_Type *ptr)
{
80008910:	1141                	addi	sp,sp,-16
80008912:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_PWM0) {
80008914:	4732                	lw	a4,12(sp)
80008916:	f04207b7          	lui	a5,0xf0420
8000891a:	04f71063          	bne	a4,a5,8000895a <.L35>
        HPM_IOC->PAD[IOC_PAD_PD00].FUNC_CTL = IOC_PD00_FUNC_CTL_PWM0_P_0;
8000891e:	f40407b7          	lui	a5,0xf4040
80008922:	4741                	li	a4,16
80008924:	30e7a023          	sw	a4,768(a5) # f4040300 <__AHB_SRAM_segment_end__+0x3e38300>
        HPM_IOC->PAD[IOC_PAD_PD01].FUNC_CTL = IOC_PD01_FUNC_CTL_PWM0_P_1;
80008928:	f40407b7          	lui	a5,0xf4040
8000892c:	4741                	li	a4,16
8000892e:	30e7a423          	sw	a4,776(a5) # f4040308 <__AHB_SRAM_segment_end__+0x3e38308>
        HPM_IOC->PAD[IOC_PAD_PD02].FUNC_CTL = IOC_PD02_FUNC_CTL_PWM0_P_2;
80008932:	f40407b7          	lui	a5,0xf4040
80008936:	4741                	li	a4,16
80008938:	30e7a823          	sw	a4,784(a5) # f4040310 <__AHB_SRAM_segment_end__+0x3e38310>
        HPM_IOC->PAD[IOC_PAD_PD03].FUNC_CTL = IOC_PD03_FUNC_CTL_PWM0_P_3;
8000893c:	f40407b7          	lui	a5,0xf4040
80008940:	4741                	li	a4,16
80008942:	30e7ac23          	sw	a4,792(a5) # f4040318 <__AHB_SRAM_segment_end__+0x3e38318>
        HPM_IOC->PAD[IOC_PAD_PD04].FUNC_CTL = IOC_PD04_FUNC_CTL_PWM0_P_4;
80008946:	f40407b7          	lui	a5,0xf4040
8000894a:	4741                	li	a4,16
8000894c:	32e7a023          	sw	a4,800(a5) # f4040320 <__AHB_SRAM_segment_end__+0x3e38320>
        HPM_IOC->PAD[IOC_PAD_PD05].FUNC_CTL = IOC_PD05_FUNC_CTL_PWM0_P_5;
80008950:	f40407b7          	lui	a5,0xf4040
80008954:	4741                	li	a4,16
80008956:	32e7a423          	sw	a4,808(a5) # f4040328 <__AHB_SRAM_segment_end__+0x3e38328>

8000895a <.L35>:
    } else {
        ;
    }
}
8000895a:	0001                	nop
8000895c:	0141                	addi	sp,sp,16
8000895e:	8082                	ret

Disassembly of section .text.init_adc16_pins:

80008960 <init_adc16_pins>:
    HPM_IOC->PAD[IOC_PAD_PF18].FUNC_CTL = IOC_PF18_FUNC_CTL_ETH0_EVTO_0;
}

void init_adc16_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PF27].FUNC_CTL = IOC_PAD_FUNC_CTL_ANALOG_MASK;
80008960:	f40407b7          	lui	a5,0xf4040
80008964:	10000713          	li	a4,256
80008968:	5ce7ac23          	sw	a4,1496(a5) # f40405d8 <__AHB_SRAM_segment_end__+0x3e385d8>
    HPM_IOC->PAD[IOC_PAD_PF24].FUNC_CTL = IOC_PAD_FUNC_CTL_ANALOG_MASK;
8000896c:	f40407b7          	lui	a5,0xf4040
80008970:	10000713          	li	a4,256
80008974:	5ce7a023          	sw	a4,1472(a5) # f40405c0 <__AHB_SRAM_segment_end__+0x3e385c0>
    HPM_IOC->PAD[IOC_PAD_PF19].FUNC_CTL = IOC_PAD_FUNC_CTL_ANALOG_MASK;
80008978:	f40407b7          	lui	a5,0xf4040
8000897c:	10000713          	li	a4,256
80008980:	58e7ac23          	sw	a4,1432(a5) # f4040598 <__AHB_SRAM_segment_end__+0x3e38598>
}
80008984:	0001                	nop
80008986:	8082                	ret

Disassembly of section .text.gptmr_check_status:

80008988 <gptmr_check_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline bool gptmr_check_status(GPTMR_Type *ptr, uint32_t mask)
{
80008988:	1141                	addi	sp,sp,-16
8000898a:	c62a                	sw	a0,12(sp)
8000898c:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
8000898e:	47b2                	lw	a5,12(sp)
80008990:	2007a703          	lw	a4,512(a5)
80008994:	47a2                	lw	a5,8(sp)
80008996:	8ff9                	and	a5,a5,a4
80008998:	4722                	lw	a4,8(sp)
8000899a:	40f707b3          	sub	a5,a4,a5
8000899e:	0017b793          	seqz	a5,a5
800089a2:	0ff7f793          	zext.b	a5,a5
}
800089a6:	853e                	mv	a0,a5
800089a8:	0141                	addi	sp,sp,16
800089aa:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

800089ac <gptmr_clear_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline void gptmr_clear_status(GPTMR_Type *ptr, uint32_t mask)
{
800089ac:	1141                	addi	sp,sp,-16
800089ae:	c62a                	sw	a0,12(sp)
800089b0:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
800089b2:	47b2                	lw	a5,12(sp)
800089b4:	4722                	lw	a4,8(sp)
800089b6:	20e7a023          	sw	a4,512(a5)
}
800089ba:	0001                	nop
800089bc:	0141                	addi	sp,sp,16
800089be:	8082                	ret

Disassembly of section .text.gpio_set_pin_input:

800089c0 <gpio_set_pin_input>:
{
800089c0:	1141                	addi	sp,sp,-16
800089c2:	c62a                	sw	a0,12(sp)
800089c4:	c42e                	sw	a1,8(sp)
800089c6:	87b2                	mv	a5,a2
800089c8:	00f103a3          	sb	a5,7(sp)
    ptr->OE[port].CLEAR = 1 << pin;
800089cc:	00714783          	lbu	a5,7(sp)
800089d0:	4705                	li	a4,1
800089d2:	00f717b3          	sll	a5,a4,a5
800089d6:	86be                	mv	a3,a5
800089d8:	4732                	lw	a4,12(sp)
800089da:	47a2                	lw	a5,8(sp)
800089dc:	02078793          	addi	a5,a5,32
800089e0:	0792                	slli	a5,a5,0x4
800089e2:	97ba                	add	a5,a5,a4
800089e4:	c794                	sw	a3,8(a5)
}
800089e6:	0001                	nop
800089e8:	0141                	addi	sp,sp,16
800089ea:	8082                	ret

Disassembly of section .text.board_print_clock_freq:

800089ec <board_print_clock_freq>:
{
800089ec:	1141                	addi	sp,sp,-16
800089ee:	c606                	sw	ra,12(sp)
    printf("==============================\n");
800089f0:	de418513          	addi	a0,gp,-540 # 80003f18 <.LC0>
800089f4:	f16fe0ef          	jal	8000710a <printf>
    printf(" %s clock summary\n", BOARD_NAME);
800089f8:	e0418593          	addi	a1,gp,-508 # 80003f38 <.LC1>
800089fc:	e1818513          	addi	a0,gp,-488 # 80003f4c <.LC2>
80008a00:	f0afe0ef          	jal	8000710a <printf>
    printf("==============================\n");
80008a04:	de418513          	addi	a0,gp,-540 # 80003f18 <.LC0>
80008a08:	f02fe0ef          	jal	8000710a <printf>
    printf("cpu0:\t\t %dHz\n", clock_get_frequency(clock_cpu0));
80008a0c:	4501                	li	a0,0
80008a0e:	d55fc0ef          	jal	80005762 <clock_get_frequency>
80008a12:	87aa                	mv	a5,a0
80008a14:	85be                	mv	a1,a5
80008a16:	e2c18513          	addi	a0,gp,-468 # 80003f60 <.LC3>
80008a1a:	ef0fe0ef          	jal	8000710a <printf>
    printf("ahb:\t\t %luHz\n", clock_get_frequency(clock_ahb0));
80008a1e:	010007b7          	lui	a5,0x1000
80008a22:	00278513          	addi	a0,a5,2 # 1000002 <__DLM_segment_end__+0xde0002>
80008a26:	d3dfc0ef          	jal	80005762 <clock_get_frequency>
80008a2a:	87aa                	mv	a5,a0
80008a2c:	85be                	mv	a1,a5
80008a2e:	e3c18513          	addi	a0,gp,-452 # 80003f70 <.LC4>
80008a32:	ed8fe0ef          	jal	8000710a <printf>
    printf("axif:\t\t %dHz\n", clock_get_frequency(clock_axif));
80008a36:	77c1                	lui	a5,0xffff0
80008a38:	00378513          	addi	a0,a5,3 # ffff0003 <__AHB_SRAM_segment_end__+0xfde8003>
80008a3c:	d27fc0ef          	jal	80005762 <clock_get_frequency>
80008a40:	87aa                	mv	a5,a0
80008a42:	85be                	mv	a1,a5
80008a44:	e4c18513          	addi	a0,gp,-436 # 80003f80 <.LC5>
80008a48:	ec2fe0ef          	jal	8000710a <printf>
    printf("axis:\t\t %dHz\n", clock_get_frequency(clock_axis));
80008a4c:	010107b7          	lui	a5,0x1010
80008a50:	00478513          	addi	a0,a5,4 # 1010004 <__DLM_segment_end__+0xdf0004>
80008a54:	d0ffc0ef          	jal	80005762 <clock_get_frequency>
80008a58:	87aa                	mv	a5,a0
80008a5a:	85be                	mv	a1,a5
80008a5c:	e5c18513          	addi	a0,gp,-420 # 80003f90 <.LC6>
80008a60:	eaafe0ef          	jal	8000710a <printf>
    printf("axic:\t\t %dHz\n", clock_get_frequency(clock_axic));
80008a64:	010207b7          	lui	a5,0x1020
80008a68:	00578513          	addi	a0,a5,5 # 1020005 <__DLM_segment_end__+0xe00005>
80008a6c:	cf7fc0ef          	jal	80005762 <clock_get_frequency>
80008a70:	87aa                	mv	a5,a0
80008a72:	85be                	mv	a1,a5
80008a74:	e6c18513          	addi	a0,gp,-404 # 80003fa0 <.LC7>
80008a78:	e92fe0ef          	jal	8000710a <printf>
    printf("xpi0:\t\t %dHz\n", clock_get_frequency(clock_xpi0));
80008a7c:	013807b7          	lui	a5,0x1380
80008a80:	02078513          	addi	a0,a5,32 # 1380020 <__NONCACHEABLE_RAM_segment_end__+0x140020>
80008a84:	cdffc0ef          	jal	80005762 <clock_get_frequency>
80008a88:	87aa                	mv	a5,a0
80008a8a:	85be                	mv	a1,a5
80008a8c:	e7c18513          	addi	a0,gp,-388 # 80003fb0 <.LC8>
80008a90:	e7afe0ef          	jal	8000710a <printf>
    printf("mchtmr0:\t %dHz\n", clock_get_frequency(clock_mchtmr0));
80008a94:	010507b7          	lui	a5,0x1050
80008a98:	00178513          	addi	a0,a5,1 # 1050001 <__DLM_segment_end__+0xe30001>
80008a9c:	cc7fc0ef          	jal	80005762 <clock_get_frequency>
80008aa0:	87aa                	mv	a5,a0
80008aa2:	85be                	mv	a1,a5
80008aa4:	e8c18513          	addi	a0,gp,-372 # 80003fc0 <.LC9>
80008aa8:	e62fe0ef          	jal	8000710a <printf>
    printf("==============================\n");
80008aac:	de418513          	addi	a0,gp,-540 # 80003f18 <.LC0>
80008ab0:	e5afe0ef          	jal	8000710a <printf>
}
80008ab4:	0001                	nop
80008ab6:	40b2                	lw	ra,12(sp)
80008ab8:	0141                	addi	sp,sp,16
80008aba:	8082                	ret

Disassembly of section .text.board_init:

80008abc <board_init>:
{
80008abc:	1141                	addi	sp,sp,-16
80008abe:	c606                	sw	ra,12(sp)
    board_init_clock();
80008ac0:	22f1                	jal	80008c8c <board_init_clock>
    board_init_console();
80008ac2:	a98fd0ef          	jal	80005d5a <board_init_console>
    board_init_pmp();
80008ac6:	28b1                	jal	80008b22 <board_init_pmp>
    board_print_clock_freq();
80008ac8:	3715                	jal	800089ec <board_print_clock_freq>
    board_print_banner();
80008aca:	adefd0ef          	jal	80005da8 <board_print_banner>
}
80008ace:	0001                	nop
80008ad0:	40b2                	lw	ra,12(sp)
80008ad2:	0141                	addi	sp,sp,16
80008ad4:	8082                	ret

Disassembly of section .text.board_delay_ms:

80008ad6 <board_delay_ms>:
{
80008ad6:	1101                	addi	sp,sp,-32
80008ad8:	ce06                	sw	ra,28(sp)
80008ada:	c62a                	sw	a0,12(sp)
    clock_cpu_delay_ms(ms);
80008adc:	4532                	lw	a0,12(sp)
80008ade:	8f8fd0ef          	jal	80005bd6 <clock_cpu_delay_ms>
}
80008ae2:	0001                	nop
80008ae4:	40f2                	lw	ra,28(sp)
80008ae6:	6105                	addi	sp,sp,32
80008ae8:	8082                	ret

Disassembly of section .text.board_init_gpio_pins:

80008aea <board_init_gpio_pins>:
{
80008aea:	1141                	addi	sp,sp,-16
80008aec:	c606                	sw	ra,12(sp)
    init_gpio_pins();
80008aee:	9e6fd0ef          	jal	80005cd4 <init_gpio_pins>
    gpio_set_pin_output_with_initial(BOARD_LED_GPIO_CTRL, BOARD_LED_GPIO_INDEX, BOARD_LED_GPIO_PIN, board_get_led_gpio_off_level());
80008af2:	aecfd0ef          	jal	80005dde <board_get_led_gpio_off_level>
80008af6:	87aa                	mv	a5,a0
80008af8:	86be                	mv	a3,a5
80008afa:	4659                	li	a2,22
80008afc:	4581                	li	a1,0
80008afe:	f00d0537          	lui	a0,0xf00d0
80008b02:	97ffd0ef          	jal	80006480 <gpio_set_pin_output_with_initial>
    gpio_set_pin_input(BOARD_KEYA_GPIO_CTRL, BOARD_KEYA_GPIO_INDEX, BOARD_KEYA_GPIO_PIN);
80008b06:	4621                	li	a2,8
80008b08:	4589                	li	a1,2
80008b0a:	f00d0537          	lui	a0,0xf00d0
80008b0e:	3d4d                	jal	800089c0 <gpio_set_pin_input>
    gpio_set_pin_input(BOARD_KEYB_GPIO_CTRL, BOARD_KEYB_GPIO_INDEX, BOARD_KEYB_GPIO_PIN);
80008b10:	4641                	li	a2,16
80008b12:	4589                	li	a1,2
80008b14:	f00d0537          	lui	a0,0xf00d0
80008b18:	3565                	jal	800089c0 <gpio_set_pin_input>
}
80008b1a:	0001                	nop
80008b1c:	40b2                	lw	ra,12(sp)
80008b1e:	0141                	addi	sp,sp,16
80008b20:	8082                	ret

Disassembly of section .text.board_init_pmp:

80008b22 <board_init_pmp>:
{
80008b22:	7169                	addi	sp,sp,-304
80008b24:	12112623          	sw	ra,300(sp)
    pmp_entry_t pmp_entry[16] = {0};
80008b28:	003c                	addi	a5,sp,8
80008b2a:	10000713          	li	a4,256
80008b2e:	863a                	mv	a2,a4
80008b30:	4581                	li	a1,0
80008b32:	853e                	mv	a0,a5
80008b34:	296020ef          	jal	8000adca <memset>
    uint8_t index = 0;
80008b38:	10010fa3          	sb	zero,287(sp)
    pmp_entry[index].pmp_addr = 0xFFFFFFFF;
80008b3c:	11f14783          	lbu	a5,287(sp)
80008b40:	0792                	slli	a5,a5,0x4
80008b42:	12078793          	addi	a5,a5,288
80008b46:	978a                	add	a5,a5,sp
80008b48:	577d                	li	a4,-1
80008b4a:	eee7a623          	sw	a4,-276(a5)
    pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
80008b4e:	11f14783          	lbu	a5,287(sp)
80008b52:	0792                	slli	a5,a5,0x4
80008b54:	12078793          	addi	a5,a5,288
80008b58:	978a                	add	a5,a5,sp
80008b5a:	477d                	li	a4,31
80008b5c:	eee78423          	sb	a4,-280(a5)
    index++;
80008b60:	11f14783          	lbu	a5,287(sp)
80008b64:	0785                	addi	a5,a5,1
80008b66:	10f10fa3          	sb	a5,287(sp)
    const uint32_t axi_sram_start = 0x01200000;  /* AXI SRAM start */
80008b6a:	012007b7          	lui	a5,0x1200
80008b6e:	10f12c23          	sw	a5,280(sp)
    const uint32_t axi_sram_end = 0x01240000;    /* AXI SRAM end */
80008b72:	012407b7          	lui	a5,0x1240
80008b76:	10f12a23          	sw	a5,276(sp)
    start_addr = (uint32_t) __noncacheable_start__;
80008b7a:	012307b7          	lui	a5,0x1230
80008b7e:	00078793          	mv	a5,a5
80008b82:	10f12823          	sw	a5,272(sp)
    end_addr = (uint32_t) __noncacheable_end__;
80008b86:	012407b7          	lui	a5,0x1240
80008b8a:	00078793          	mv	a5,a5
80008b8e:	10f12623          	sw	a5,268(sp)
    if ((start_addr >= axi_sram_start) && (end_addr <= axi_sram_end)) {
80008b92:	11012703          	lw	a4,272(sp)
80008b96:	11812783          	lw	a5,280(sp)
80008b9a:	0cf76e63          	bltu	a4,a5,80008c76 <.L82>
80008b9e:	10c12703          	lw	a4,268(sp)
80008ba2:	11412783          	lw	a5,276(sp)
80008ba6:	0ce7e863          	bltu	a5,a4,80008c76 <.L82>
        length = end_addr - start_addr;
80008baa:	10c12703          	lw	a4,268(sp)
80008bae:	11012783          	lw	a5,272(sp)
80008bb2:	40f707b3          	sub	a5,a4,a5
80008bb6:	10f12423          	sw	a5,264(sp)
        if (length > 0) {
80008bba:	10812783          	lw	a5,264(sp)
80008bbe:	cfc5                	beqz	a5,80008c76 <.L82>
            assert((length & (length - 1U)) == 0U);
80008bc0:	10812783          	lw	a5,264(sp)
80008bc4:	fff78713          	addi	a4,a5,-1 # 123ffff <__NONCACHEABLE_RAM_segment_used_end__+0xef3f>
80008bc8:	10812783          	lw	a5,264(sp)
80008bcc:	8ff9                	and	a5,a5,a4
80008bce:	cb89                	beqz	a5,80008be0 <.L83>
80008bd0:	18c00613          	li	a2,396
80008bd4:	1ac18593          	addi	a1,gp,428 # 800042e0 <.LC17>
80008bd8:	1e018513          	addi	a0,gp,480 # 80004314 <.LC18>
80008bdc:	bf1fd0ef          	jal	800067cc <__SEGGER_RTL_X_assert>

80008be0 <.L83>:
            assert((start_addr & (length - 1U)) == 0U);
80008be0:	10812783          	lw	a5,264(sp)
80008be4:	fff78713          	addi	a4,a5,-1
80008be8:	11012783          	lw	a5,272(sp)
80008bec:	8ff9                	and	a5,a5,a4
80008bee:	cb89                	beqz	a5,80008c00 <.L84>
80008bf0:	18d00613          	li	a2,397
80008bf4:	1ac18593          	addi	a1,gp,428 # 800042e0 <.LC17>
80008bf8:	20018513          	addi	a0,gp,512 # 80004334 <.LC19>
80008bfc:	bd1fd0ef          	jal	800067cc <__SEGGER_RTL_X_assert>

80008c00 <.L84>:
            pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
80008c00:	10812783          	lw	a5,264(sp)
80008c04:	0017d713          	srli	a4,a5,0x1
80008c08:	11012783          	lw	a5,272(sp)
80008c0c:	97ba                	add	a5,a5,a4
80008c0e:	fff78713          	addi	a4,a5,-1
80008c12:	11f14783          	lbu	a5,287(sp)
80008c16:	8309                	srli	a4,a4,0x2
80008c18:	0792                	slli	a5,a5,0x4
80008c1a:	12078793          	addi	a5,a5,288
80008c1e:	978a                	add	a5,a5,sp
80008c20:	eee7a623          	sw	a4,-276(a5)
            pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
80008c24:	11f14783          	lbu	a5,287(sp)
80008c28:	0792                	slli	a5,a5,0x4
80008c2a:	12078793          	addi	a5,a5,288
80008c2e:	978a                	add	a5,a5,sp
80008c30:	477d                	li	a4,31
80008c32:	eee78423          	sb	a4,-280(a5)
            pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
80008c36:	10812783          	lw	a5,264(sp)
80008c3a:	0017d713          	srli	a4,a5,0x1
80008c3e:	11012783          	lw	a5,272(sp)
80008c42:	97ba                	add	a5,a5,a4
80008c44:	fff78713          	addi	a4,a5,-1
80008c48:	11f14783          	lbu	a5,287(sp)
80008c4c:	8309                	srli	a4,a4,0x2
80008c4e:	0792                	slli	a5,a5,0x4
80008c50:	12078793          	addi	a5,a5,288
80008c54:	978a                	add	a5,a5,sp
80008c56:	eee7aa23          	sw	a4,-268(a5)
            pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
80008c5a:	11f14783          	lbu	a5,287(sp)
80008c5e:	0792                	slli	a5,a5,0x4
80008c60:	12078793          	addi	a5,a5,288
80008c64:	978a                	add	a5,a5,sp
80008c66:	473d                	li	a4,15
80008c68:	eee78823          	sb	a4,-272(a5)
            index++;
80008c6c:	11f14783          	lbu	a5,287(sp)
80008c70:	0785                	addi	a5,a5,1
80008c72:	10f10fa3          	sb	a5,287(sp)

80008c76 <.L82>:
    pmp_config(&pmp_entry[0], index);
80008c76:	11f14703          	lbu	a4,287(sp)
80008c7a:	003c                	addi	a5,sp,8
80008c7c:	85ba                	mv	a1,a4
80008c7e:	853e                	mv	a0,a5
80008c80:	2d79                	jal	8000931e <pmp_config>
}
80008c82:	0001                	nop
80008c84:	12c12083          	lw	ra,300(sp)
80008c88:	6155                	addi	sp,sp,304
80008c8a:	8082                	ret

Disassembly of section .text.board_init_clock:

80008c8c <board_init_clock>:
{
80008c8c:	1101                	addi	sp,sp,-32
80008c8e:	ce06                	sw	ra,28(sp)
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
80008c90:	4501                	li	a0,0
80008c92:	ad1fc0ef          	jal	80005762 <clock_get_frequency>
80008c96:	c62a                	sw	a0,12(sp)
    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ) {
80008c98:	4732                	lw	a4,12(sp)
80008c9a:	016e37b7          	lui	a5,0x16e3
80008c9e:	60078793          	addi	a5,a5,1536 # 16e3600 <__NONCACHEABLE_RAM_segment_end__+0x4a3600>
80008ca2:	00f71f63          	bne	a4,a5,80008cc0 <.L86>
        pllctlv2_xtal_set_rampup_time(HPM_PLLCTLV2, 32ul * 1000ul * 9u);
80008ca6:	000467b7          	lui	a5,0x46
80008caa:	50078593          	addi	a1,a5,1280 # 46500 <__AXI_SRAM_segment_size__+0x16500>
80008cae:	f40c0537          	lui	a0,0xf40c0
80008cb2:	882fd0ef          	jal	80005d34 <pllctlv2_xtal_set_rampup_time>
        sysctl_clock_set_preset(HPM_SYSCTL, 2);
80008cb6:	4589                	li	a1,2
80008cb8:	f4000537          	lui	a0,0xf4000
80008cbc:	84efd0ef          	jal	80005d0a <sysctl_clock_set_preset>

80008cc0 <.L86>:
    clock_add_to_group(clock_cpu0, 0);
80008cc0:	4581                	li	a1,0
80008cc2:	4501                	li	a0,0
80008cc4:	ed9fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_mchtmr0, 0);
80008cc8:	4581                	li	a1,0
80008cca:	010507b7          	lui	a5,0x1050
80008cce:	00178513          	addi	a0,a5,1 # 1050001 <__DLM_segment_end__+0xe30001>
80008cd2:	ecbfc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_ahb0, 0);
80008cd6:	4581                	li	a1,0
80008cd8:	010007b7          	lui	a5,0x1000
80008cdc:	00278513          	addi	a0,a5,2 # 1000002 <__DLM_segment_end__+0xde0002>
80008ce0:	ebdfc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_axif, 0);
80008ce4:	4581                	li	a1,0
80008ce6:	77c1                	lui	a5,0xffff0
80008ce8:	00378513          	addi	a0,a5,3 # ffff0003 <__AHB_SRAM_segment_end__+0xfde8003>
80008cec:	eb1fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_axis, 0);
80008cf0:	4581                	li	a1,0
80008cf2:	010107b7          	lui	a5,0x1010
80008cf6:	00478513          	addi	a0,a5,4 # 1010004 <__DLM_segment_end__+0xdf0004>
80008cfa:	ea3fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_axic, 0);
80008cfe:	4581                	li	a1,0
80008d00:	010207b7          	lui	a5,0x1020
80008d04:	00578513          	addi	a0,a5,5 # 1020005 <__DLM_segment_end__+0xe00005>
80008d08:	e95fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_rom0, 0);
80008d0c:	4581                	li	a1,0
80008d0e:	010307b7          	lui	a5,0x1030
80008d12:	50678513          	addi	a0,a5,1286 # 1030506 <__DLM_segment_end__+0xe10506>
80008d16:	e87fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_xpi0, 0);
80008d1a:	4581                	li	a1,0
80008d1c:	013807b7          	lui	a5,0x1380
80008d20:	02078513          	addi	a0,a5,32 # 1380020 <__NONCACHEABLE_RAM_segment_end__+0x140020>
80008d24:	e79fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_lmm0, 0);
80008d28:	4581                	li	a1,0
80008d2a:	010417b7          	lui	a5,0x1041
80008d2e:	90078513          	addi	a0,a5,-1792 # 1040900 <__DLM_segment_end__+0xe20900>
80008d32:	e6bfc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_ram0, 0);
80008d36:	4581                	li	a1,0
80008d38:	013907b7          	lui	a5,0x1390
80008d3c:	40078513          	addi	a0,a5,1024 # 1390400 <__NONCACHEABLE_RAM_segment_end__+0x150400>
80008d40:	e5dfc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_hdma, 0);
80008d44:	4581                	li	a1,0
80008d46:	012507b7          	lui	a5,0x1250
80008d4a:	30078513          	addi	a0,a5,768 # 1250300 <__NONCACHEABLE_RAM_segment_end__+0x10300>
80008d4e:	e4ffc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_xdma, 0);
80008d52:	4581                	li	a1,0
80008d54:	013a07b7          	lui	a5,0x13a0
80008d58:	50478513          	addi	a0,a5,1284 # 13a0504 <__NONCACHEABLE_RAM_segment_end__+0x160504>
80008d5c:	e41fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_gpio, 0);
80008d60:	4581                	li	a1,0
80008d62:	012307b7          	lui	a5,0x1230
80008d66:	30078513          	addi	a0,a5,768 # 1230300 <seq_buff+0x300>
80008d6a:	e33fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_ptpc, 0);
80008d6e:	4581                	li	a1,0
80008d70:	012e07b7          	lui	a5,0x12e0
80008d74:	30078513          	addi	a0,a5,768 # 12e0300 <__NONCACHEABLE_RAM_segment_end__+0xa0300>
80008d78:	e25fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_qei0, 0);
80008d7c:	4581                	li	a1,0
80008d7e:	012f07b7          	lui	a5,0x12f0
80008d82:	30078513          	addi	a0,a5,768 # 12f0300 <__NONCACHEABLE_RAM_segment_end__+0xb0300>
80008d86:	e17fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_plb0, 0);
80008d8a:	4581                	li	a1,0
80008d8c:	013407b7          	lui	a5,0x1340
80008d90:	30078513          	addi	a0,a5,768 # 1340300 <__NONCACHEABLE_RAM_segment_end__+0x100300>
80008d94:	e09fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_qei1, 0);
80008d98:	4581                	li	a1,0
80008d9a:	013007b7          	lui	a5,0x1300
80008d9e:	30078513          	addi	a0,a5,768 # 1300300 <__NONCACHEABLE_RAM_segment_end__+0xc0300>
80008da2:	dfbfc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_qeo0, 0);
80008da6:	4581                	li	a1,0
80008da8:	013107b7          	lui	a5,0x1310
80008dac:	30078513          	addi	a0,a5,768 # 1310300 <__NONCACHEABLE_RAM_segment_end__+0xd0300>
80008db0:	dedfc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_qeo1, 0);
80008db4:	4581                	li	a1,0
80008db6:	013207b7          	lui	a5,0x1320
80008dba:	30078513          	addi	a0,a5,768 # 1320300 <__NONCACHEABLE_RAM_segment_end__+0xe0300>
80008dbe:	ddffc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_pwm0, 0);
80008dc2:	4581                	li	a1,0
80008dc4:	013507b7          	lui	a5,0x1350
80008dc8:	30078513          	addi	a0,a5,768 # 1350300 <__NONCACHEABLE_RAM_segment_end__+0x110300>
80008dcc:	dd1fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_pwm1, 0);
80008dd0:	4581                	li	a1,0
80008dd2:	013607b7          	lui	a5,0x1360
80008dd6:	30078513          	addi	a0,a5,768 # 1360300 <__NONCACHEABLE_RAM_segment_end__+0x120300>
80008dda:	dc3fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_add_to_group(clock_emds, 0);
80008dde:	4581                	li	a1,0
80008de0:	013707b7          	lui	a5,0x1370
80008de4:	30078513          	addi	a0,a5,768 # 1370300 <__NONCACHEABLE_RAM_segment_end__+0x130300>
80008de8:	db5fc0ef          	jal	80005b9c <clock_add_to_group>
    clock_connect_group_to_cpu(0, 0);
80008dec:	4581                	li	a1,0
80008dee:	4501                	li	a0,0
80008df0:	34a9                	jal	8000883a <clock_connect_group_to_cpu>
    pcfg_dcdc_set_voltage(HPM_PCFG, 1275);
80008df2:	4fb00593          	li	a1,1275
80008df6:	f4104537          	lui	a0,0xf4104
80008dfa:	73f000ef          	jal	80009d38 <pcfg_dcdc_set_voltage>
    pcfg_dcdc_switch_to_dcm_mode(HPM_PCFG);
80008dfe:	f4104537          	lui	a0,0xf4104
80008e02:	887fd0ef          	jal	80006688 <pcfg_dcdc_switch_to_dcm_mode>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk0, pllctlv2_div_1p0);    /* PLL0CLK0: 480MHz */
80008e06:	4681                	li	a3,0
80008e08:	4601                	li	a2,0
80008e0a:	4581                	li	a1,0
80008e0c:	f40c0537          	lui	a0,0xf40c0
80008e10:	259d                	jal	80009476 <pllctlv2_set_postdiv>
    pllctlv2_set_postdiv(HPM_PLLCTLV2, pllctlv2_pll0, pllctlv2_clk1, pllctlv2_div_1p2);    /* PLL0CLK1: 400MHz */
80008e12:	4685                	li	a3,1
80008e14:	4605                	li	a2,1
80008e16:	4581                	li	a1,0
80008e18:	f40c0537          	lui	a0,0xf40c0
80008e1c:	2da9                	jal	80009476 <pllctlv2_set_postdiv>
    pllctlv2_init_pll_with_freq(HPM_PLLCTLV2, pllctlv2_pll0, BOARD_CPU_FREQ);
80008e1e:	1c9c47b7          	lui	a5,0x1c9c4
80008e22:	80078613          	addi	a2,a5,-2048 # 1c9c3800 <__NONCACHEABLE_RAM_segment_end__+0x1b783800>
80008e26:	4581                	li	a1,0
80008e28:	f40c0537          	lui	a0,0xf40c0
80008e2c:	f62fd0ef          	jal	8000658e <pllctlv2_init_pll_with_freq>
    clock_set_source_divider(clock_cpu0, clk_src_pll0_clk0, 1);
80008e30:	4605                	li	a2,1
80008e32:	4585                	li	a1,1
80008e34:	4501                	li	a0,0
80008e36:	ca3fc0ef          	jal	80005ad8 <clock_set_source_divider>
    clock_update_core_clock();
80008e3a:	3cb9                	jal	80008898 <clock_update_core_clock>
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
80008e3c:	4605                	li	a2,1
80008e3e:	4581                	li	a1,0
80008e40:	010507b7          	lui	a5,0x1050
80008e44:	00178513          	addi	a0,a5,1 # 1050001 <__DLM_segment_end__+0xe30001>
80008e48:	c91fc0ef          	jal	80005ad8 <clock_set_source_divider>
}
80008e4c:	0001                	nop
80008e4e:	40f2                	lw	ra,28(sp)
80008e50:	6105                	addi	sp,sp,32
80008e52:	8082                	ret

Disassembly of section .text.board_init_adc16_pins:

80008e54 <board_init_adc16_pins>:
{
80008e54:	1141                	addi	sp,sp,-16
80008e56:	c606                	sw	ra,12(sp)
    init_adc16_pins();
80008e58:	3621                	jal	80008960 <init_adc16_pins>
}
80008e5a:	0001                	nop
80008e5c:	40b2                	lw	ra,12(sp)
80008e5e:	0141                	addi	sp,sp,16
80008e60:	8082                	ret

Disassembly of section .text.uart_modem_config:

80008e62 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
80008e62:	1141                	addi	sp,sp,-16
80008e64:	c62a                	sw	a0,12(sp)
80008e66:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80008e68:	47a2                	lw	a5,8(sp)
80008e6a:	0007c783          	lbu	a5,0(a5)
80008e6e:	0796                	slli	a5,a5,0x5
80008e70:	0207f713          	andi	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
80008e74:	47a2                	lw	a5,8(sp)
80008e76:	0017c783          	lbu	a5,1(a5)
80008e7a:	0792                	slli	a5,a5,0x4
80008e7c:	8bc1                	andi	a5,a5,16
80008e7e:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
80008e80:	47a2                	lw	a5,8(sp)
80008e82:	0027c783          	lbu	a5,2(a5)
80008e86:	0017c793          	xori	a5,a5,1
80008e8a:	0ff7f793          	zext.b	a5,a5
80008e8e:	0786                	slli	a5,a5,0x1
80008e90:	8b89                	andi	a5,a5,2
80008e92:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
80008e94:	47b2                	lw	a5,12(sp)
80008e96:	db98                	sw	a4,48(a5)
}
80008e98:	0001                	nop
80008e9a:	0141                	addi	sp,sp,16
80008e9c:	8082                	ret

Disassembly of section .text.uart_disable_irq:

80008e9e <uart_disable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be disabled
 */
static inline void uart_disable_irq(UART_Type *ptr, uint32_t irq_mask)
{
80008e9e:	1141                	addi	sp,sp,-16
80008ea0:	c62a                	sw	a0,12(sp)
80008ea2:	c42e                	sw	a1,8(sp)
    ptr->IER &= ~irq_mask;
80008ea4:	47b2                	lw	a5,12(sp)
80008ea6:	53d8                	lw	a4,36(a5)
80008ea8:	47a2                	lw	a5,8(sp)
80008eaa:	fff7c793          	not	a5,a5
80008eae:	8f7d                	and	a4,a4,a5
80008eb0:	47b2                	lw	a5,12(sp)
80008eb2:	d3d8                	sw	a4,36(a5)
}
80008eb4:	0001                	nop
80008eb6:	0141                	addi	sp,sp,16
80008eb8:	8082                	ret

Disassembly of section .text.uart_enable_irq:

80008eba <uart_enable_irq>:
 *
 * @param [in] ptr UART base address
 * @param irq_mask IRQ mask value to be enabled
 */
static inline void uart_enable_irq(UART_Type *ptr, uint32_t irq_mask)
{
80008eba:	1141                	addi	sp,sp,-16
80008ebc:	c62a                	sw	a0,12(sp)
80008ebe:	c42e                	sw	a1,8(sp)
    ptr->IER |= irq_mask;
80008ec0:	47b2                	lw	a5,12(sp)
80008ec2:	53d8                	lw	a4,36(a5)
80008ec4:	47a2                	lw	a5,8(sp)
80008ec6:	8f5d                	or	a4,a4,a5
80008ec8:	47b2                	lw	a5,12(sp)
80008eca:	d3d8                	sw	a4,36(a5)
}
80008ecc:	0001                	nop
80008ece:	0141                	addi	sp,sp,16
80008ed0:	8082                	ret

Disassembly of section .text.uart_default_config:

80008ed2 <uart_default_config>:
{
80008ed2:	1141                	addi	sp,sp,-16
80008ed4:	c62a                	sw	a0,12(sp)
80008ed6:	c42e                	sw	a1,8(sp)
    config->baudrate = 115200;
80008ed8:	47a2                	lw	a5,8(sp)
80008eda:	6771                	lui	a4,0x1c
80008edc:	20070713          	addi	a4,a4,512 # 1c200 <__NONCACHEABLE_RAM_segment_size__+0xc200>
80008ee0:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
80008ee2:	47a2                	lw	a5,8(sp)
80008ee4:	470d                	li	a4,3
80008ee6:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
80008eea:	47a2                	lw	a5,8(sp)
80008eec:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
80008ef0:	47a2                	lw	a5,8(sp)
80008ef2:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
80008ef6:	47a2                	lw	a5,8(sp)
80008ef8:	4705                	li	a4,1
80008efa:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
80008efe:	47a2                	lw	a5,8(sp)
80008f00:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
80008f04:	47a2                	lw	a5,8(sp)
80008f06:	477d                	li	a4,31
80008f08:	00e785a3          	sb	a4,11(a5)
    config->dma_enable = false;
80008f0c:	47a2                	lw	a5,8(sp)
80008f0e:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
80008f12:	47a2                	lw	a5,8(sp)
80008f14:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
80008f18:	47a2                	lw	a5,8(sp)
80008f1a:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
80008f1e:	47a2                	lw	a5,8(sp)
80008f20:	000788a3          	sb	zero,17(a5)
    config->rxidle_config.detect_enable = false;
80008f24:	47a2                	lw	a5,8(sp)
80008f26:	00078923          	sb	zero,18(a5)
    config->rxidle_config.detect_irq_enable = false;
80008f2a:	47a2                	lw	a5,8(sp)
80008f2c:	000789a3          	sb	zero,19(a5)
    config->rxidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
80008f30:	47a2                	lw	a5,8(sp)
80008f32:	00078a23          	sb	zero,20(a5)
    config->rxidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
80008f36:	47a2                	lw	a5,8(sp)
80008f38:	4729                	li	a4,10
80008f3a:	00e78aa3          	sb	a4,21(a5)
    config->txidle_config.detect_enable = false;
80008f3e:	47a2                	lw	a5,8(sp)
80008f40:	00078b23          	sb	zero,22(a5)
    config->txidle_config.detect_irq_enable = false;
80008f44:	47a2                	lw	a5,8(sp)
80008f46:	00078ba3          	sb	zero,23(a5)
    config->txidle_config.idle_cond = uart_rxline_idle_cond_rxline_logic_one;
80008f4a:	47a2                	lw	a5,8(sp)
80008f4c:	00078c23          	sb	zero,24(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
80008f50:	47a2                	lw	a5,8(sp)
80008f52:	4729                	li	a4,10
80008f54:	00e78ca3          	sb	a4,25(a5)
    config->rx_enable = true;
80008f58:	47a2                	lw	a5,8(sp)
80008f5a:	4705                	li	a4,1
80008f5c:	00e78d23          	sb	a4,26(a5)
}
80008f60:	0001                	nop
80008f62:	0141                	addi	sp,sp,16
80008f64:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

80008f66 <uart_calculate_baudrate>:
{
80008f66:	711d                	addi	sp,sp,-96
80008f68:	ce86                	sw	ra,92(sp)
80008f6a:	cca2                	sw	s0,88(sp)
80008f6c:	caa6                	sw	s1,84(sp)
80008f6e:	c8ca                	sw	s2,80(sp)
80008f70:	c6ce                	sw	s3,76(sp)
80008f72:	c4d2                	sw	s4,72(sp)
80008f74:	c2d6                	sw	s5,68(sp)
80008f76:	c0da                	sw	s6,64(sp)
80008f78:	de5e                	sw	s7,60(sp)
80008f7a:	dc62                	sw	s8,56(sp)
80008f7c:	da66                	sw	s9,52(sp)
80008f7e:	c62a                	sw	a0,12(sp)
80008f80:	c42e                	sw	a1,8(sp)
80008f82:	c232                	sw	a2,4(sp)
80008f84:	c036                	sw	a3,0(sp)
    if ((div_out == NULL) || (!freq) || (!baudrate)
80008f86:	4692                	lw	a3,4(sp)
80008f88:	ca9d                	beqz	a3,80008fbe <.L6>
80008f8a:	46b2                	lw	a3,12(sp)
80008f8c:	ca8d                	beqz	a3,80008fbe <.L6>
80008f8e:	46a2                	lw	a3,8(sp)
80008f90:	c69d                	beqz	a3,80008fbe <.L6>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
80008f92:	4622                	lw	a2,8(sp)
80008f94:	0c700693          	li	a3,199
80008f98:	02c6f363          	bgeu	a3,a2,80008fbe <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
80008f9c:	46a2                	lw	a3,8(sp)
80008f9e:	068e                	slli	a3,a3,0x3
80008fa0:	4632                	lw	a2,12(sp)
80008fa2:	00d66e63          	bltu	a2,a3,80008fbe <.L6>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
80008fa6:	4632                	lw	a2,12(sp)
80008fa8:	800086b7          	lui	a3,0x80008
80008fac:	0685                	addi	a3,a3,1 # 80008001 <pwmv2_set_shadow_val+0x33>
80008fae:	02d636b3          	mulhu	a3,a2,a3
80008fb2:	00f6d613          	srli	a2,a3,0xf
80008fb6:	46a2                	lw	a3,8(sp)
80008fb8:	0696                	slli	a3,a3,0x5
80008fba:	00c6f463          	bgeu	a3,a2,80008fc2 <.L7>

80008fbe <.L6>:
        return 0;
80008fbe:	4781                	li	a5,0
80008fc0:	a2fd                	j	800091ae <.L8>

80008fc2 <.L7>:
    tmp = ((uint64_t)freq * HPM_UART_BAUDRATE_SCALE) / baudrate;
80008fc2:	46b2                	lw	a3,12(sp)
80008fc4:	8736                	mv	a4,a3
80008fc6:	4781                	li	a5,0
80008fc8:	3e800693          	li	a3,1000
80008fcc:	02d78633          	mul	a2,a5,a3
80008fd0:	4681                	li	a3,0
80008fd2:	02d706b3          	mul	a3,a4,a3
80008fd6:	9636                	add	a2,a2,a3
80008fd8:	3e800693          	li	a3,1000
80008fdc:	02d705b3          	mul	a1,a4,a3
80008fe0:	02d738b3          	mulhu	a7,a4,a3
80008fe4:	882e                	mv	a6,a1
80008fe6:	011607b3          	add	a5,a2,a7
80008fea:	88be                	mv	a7,a5
80008fec:	47a2                	lw	a5,8(sp)
80008fee:	833e                	mv	t1,a5
80008ff0:	4381                	li	t2,0
80008ff2:	861a                	mv	a2,t1
80008ff4:	869e                	mv	a3,t2
80008ff6:	8542                	mv	a0,a6
80008ff8:	85c6                	mv	a1,a7
80008ffa:	4e4010ef          	jal	8000a4de <__udivdi3>
80008ffe:	872a                	mv	a4,a0
80009000:	87ae                	mv	a5,a1
80009002:	d03a                	sw	a4,32(sp)
80009004:	d23e                	sw	a5,36(sp)
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
80009006:	47a1                	li	a5,8
80009008:	d63e                	sw	a5,44(sp)
8000900a:	aa61                	j	800091a2 <.L9>

8000900c <.L21>:
        delta = 0;
8000900c:	d402                	sw	zero,40(sp)
        div = (uint32_t)((tmp + osc * (HPM_UART_BAUDRATE_SCALE / 2)) / (osc * HPM_UART_BAUDRATE_SCALE));
8000900e:	5732                	lw	a4,44(sp)
80009010:	87ba                	mv	a5,a4
80009012:	078a                	slli	a5,a5,0x2
80009014:	97ba                	add	a5,a5,a4
80009016:	00279713          	slli	a4,a5,0x2
8000901a:	97ba                	add	a5,a5,a4
8000901c:	00279713          	slli	a4,a5,0x2
80009020:	97ba                	add	a5,a5,a4
80009022:	078a                	slli	a5,a5,0x2
80009024:	843e                	mv	s0,a5
80009026:	4481                	li	s1,0
80009028:	5602                	lw	a2,32(sp)
8000902a:	5692                	lw	a3,36(sp)
8000902c:	00c40733          	add	a4,s0,a2
80009030:	85ba                	mv	a1,a4
80009032:	0085b5b3          	sltu	a1,a1,s0
80009036:	00d487b3          	add	a5,s1,a3
8000903a:	00f586b3          	add	a3,a1,a5
8000903e:	87b6                	mv	a5,a3
80009040:	853a                	mv	a0,a4
80009042:	85be                	mv	a1,a5
80009044:	5732                	lw	a4,44(sp)
80009046:	87ba                	mv	a5,a4
80009048:	078a                	slli	a5,a5,0x2
8000904a:	97ba                	add	a5,a5,a4
8000904c:	00279713          	slli	a4,a5,0x2
80009050:	97ba                	add	a5,a5,a4
80009052:	00279713          	slli	a4,a5,0x2
80009056:	97ba                	add	a5,a5,a4
80009058:	078e                	slli	a5,a5,0x3
8000905a:	8b3e                	mv	s6,a5
8000905c:	4b81                	li	s7,0
8000905e:	865a                	mv	a2,s6
80009060:	86de                	mv	a3,s7
80009062:	47c010ef          	jal	8000a4de <__udivdi3>
80009066:	872a                	mv	a4,a0
80009068:	87ae                	mv	a5,a1
8000906a:	ce3a                	sw	a4,28(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN || div > HPM_UART_BAUDRATE_DIV_MAX) {
8000906c:	47f2                	lw	a5,28(sp)
8000906e:	12078463          	beqz	a5,80009196 <.L24>
80009072:	4772                	lw	a4,28(sp)
80009074:	67c1                	lui	a5,0x10
80009076:	12f77063          	bgeu	a4,a5,80009196 <.L24>
        if ((div * osc * HPM_UART_BAUDRATE_SCALE) > tmp) {
8000907a:	4772                	lw	a4,28(sp)
8000907c:	57b2                	lw	a5,44(sp)
8000907e:	02f70733          	mul	a4,a4,a5
80009082:	87ba                	mv	a5,a4
80009084:	078a                	slli	a5,a5,0x2
80009086:	97ba                	add	a5,a5,a4
80009088:	00279713          	slli	a4,a5,0x2
8000908c:	97ba                	add	a5,a5,a4
8000908e:	00279713          	slli	a4,a5,0x2
80009092:	97ba                	add	a5,a5,a4
80009094:	078e                	slli	a5,a5,0x3
80009096:	893e                	mv	s2,a5
80009098:	4981                	li	s3,0
8000909a:	5792                	lw	a5,36(sp)
8000909c:	874e                	mv	a4,s3
8000909e:	00e7ea63          	bltu	a5,a4,800090b2 <.L22>
800090a2:	5792                	lw	a5,36(sp)
800090a4:	874e                	mv	a4,s3
800090a6:	02e79a63          	bne	a5,a4,800090da <.L13>
800090aa:	5782                	lw	a5,32(sp)
800090ac:	874a                	mv	a4,s2
800090ae:	02e7f663          	bgeu	a5,a4,800090da <.L13>

800090b2 <.L22>:
            delta = (uint32_t)((div * osc * HPM_UART_BAUDRATE_SCALE) - tmp);
800090b2:	4772                	lw	a4,28(sp)
800090b4:	57b2                	lw	a5,44(sp)
800090b6:	02f70733          	mul	a4,a4,a5
800090ba:	87ba                	mv	a5,a4
800090bc:	078a                	slli	a5,a5,0x2
800090be:	97ba                	add	a5,a5,a4
800090c0:	00279713          	slli	a4,a5,0x2
800090c4:	97ba                	add	a5,a5,a4
800090c6:	00279713          	slli	a4,a5,0x2
800090ca:	97ba                	add	a5,a5,a4
800090cc:	078e                	slli	a5,a5,0x3
800090ce:	873e                	mv	a4,a5
800090d0:	5782                	lw	a5,32(sp)
800090d2:	40f707b3          	sub	a5,a4,a5
800090d6:	d43e                	sw	a5,40(sp)
800090d8:	a8b9                	j	80009136 <.L15>

800090da <.L13>:
        } else if ((div * osc * HPM_UART_BAUDRATE_SCALE) < tmp) {
800090da:	4772                	lw	a4,28(sp)
800090dc:	57b2                	lw	a5,44(sp)
800090de:	02f70733          	mul	a4,a4,a5
800090e2:	87ba                	mv	a5,a4
800090e4:	078a                	slli	a5,a5,0x2
800090e6:	97ba                	add	a5,a5,a4
800090e8:	00279713          	slli	a4,a5,0x2
800090ec:	97ba                	add	a5,a5,a4
800090ee:	00279713          	slli	a4,a5,0x2
800090f2:	97ba                	add	a5,a5,a4
800090f4:	078e                	slli	a5,a5,0x3
800090f6:	8a3e                	mv	s4,a5
800090f8:	4a81                	li	s5,0
800090fa:	5792                	lw	a5,36(sp)
800090fc:	8756                	mv	a4,s5
800090fe:	00f76a63          	bltu	a4,a5,80009112 <.L23>
80009102:	5792                	lw	a5,36(sp)
80009104:	8756                	mv	a4,s5
80009106:	02e79863          	bne	a5,a4,80009136 <.L15>
8000910a:	5782                	lw	a5,32(sp)
8000910c:	8752                	mv	a4,s4
8000910e:	02f77463          	bgeu	a4,a5,80009136 <.L15>

80009112 <.L23>:
            delta = (uint32_t)(tmp - (div * osc * HPM_UART_BAUDRATE_SCALE));
80009112:	5682                	lw	a3,32(sp)
80009114:	4772                	lw	a4,28(sp)
80009116:	57b2                	lw	a5,44(sp)
80009118:	02f70733          	mul	a4,a4,a5
8000911c:	87ba                	mv	a5,a4
8000911e:	078a                	slli	a5,a5,0x2
80009120:	97ba                	add	a5,a5,a4
80009122:	00279713          	slli	a4,a5,0x2
80009126:	97ba                	add	a5,a5,a4
80009128:	00279713          	slli	a4,a5,0x2
8000912c:	97ba                	add	a5,a5,a4
8000912e:	078e                	slli	a5,a5,0x3
80009130:	40f687b3          	sub	a5,a3,a5
80009134:	d43e                	sw	a5,40(sp)

80009136 <.L15>:
        if (delta && (((delta * 100) / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
80009136:	57a2                	lw	a5,40(sp)
80009138:	cb95                	beqz	a5,8000916c <.L17>
8000913a:	5722                	lw	a4,40(sp)
8000913c:	87ba                	mv	a5,a4
8000913e:	078a                	slli	a5,a5,0x2
80009140:	97ba                	add	a5,a5,a4
80009142:	00279713          	slli	a4,a5,0x2
80009146:	97ba                	add	a5,a5,a4
80009148:	078a                	slli	a5,a5,0x2
8000914a:	8c3e                	mv	s8,a5
8000914c:	4c81                	li	s9,0
8000914e:	5602                	lw	a2,32(sp)
80009150:	5692                	lw	a3,36(sp)
80009152:	8562                	mv	a0,s8
80009154:	85e6                	mv	a1,s9
80009156:	388010ef          	jal	8000a4de <__udivdi3>
8000915a:	872a                	mv	a4,a0
8000915c:	87ae                	mv	a5,a1
8000915e:	86be                	mv	a3,a5
80009160:	ee8d                	bnez	a3,8000919a <.L25>
80009162:	86be                	mv	a3,a5
80009164:	e681                	bnez	a3,8000916c <.L17>
80009166:	478d                	li	a5,3
80009168:	02e7e963          	bltu	a5,a4,8000919a <.L25>

8000916c <.L17>:
            *div_out = div;
8000916c:	47f2                	lw	a5,28(sp)
8000916e:	0807c733          	zext.h	a4,a5
80009172:	4792                	lw	a5,4(sp)
80009174:	00e79023          	sh	a4,0(a5) # 10000 <__NONCACHEABLE_RAM_segment_size__>
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
80009178:	5732                	lw	a4,44(sp)
8000917a:	02000793          	li	a5,32
8000917e:	00f70663          	beq	a4,a5,8000918a <.L19>
80009182:	57b2                	lw	a5,44(sp)
80009184:	0ff7f793          	zext.b	a5,a5
80009188:	a011                	j	8000918c <.L20>

8000918a <.L19>:
8000918a:	4781                	li	a5,0

8000918c <.L20>:
8000918c:	4702                	lw	a4,0(sp)
8000918e:	00f70023          	sb	a5,0(a4)
            return true;
80009192:	4785                	li	a5,1
80009194:	a829                	j	800091ae <.L8>

80009196 <.L24>:
            continue;
80009196:	0001                	nop
80009198:	a011                	j	8000919c <.L12>

8000919a <.L25>:
            continue;
8000919a:	0001                	nop

8000919c <.L12>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
8000919c:	57b2                	lw	a5,44(sp)
8000919e:	0789                	addi	a5,a5,2
800091a0:	d63e                	sw	a5,44(sp)

800091a2 <.L9>:
800091a2:	5732                	lw	a4,44(sp)
800091a4:	02000793          	li	a5,32
800091a8:	e6e7f2e3          	bgeu	a5,a4,8000900c <.L21>
    return false;
800091ac:	4781                	li	a5,0

800091ae <.L8>:
}
800091ae:	853e                	mv	a0,a5
800091b0:	40f6                	lw	ra,92(sp)
800091b2:	4466                	lw	s0,88(sp)
800091b4:	44d6                	lw	s1,84(sp)
800091b6:	4946                	lw	s2,80(sp)
800091b8:	49b6                	lw	s3,76(sp)
800091ba:	4a26                	lw	s4,72(sp)
800091bc:	4a96                	lw	s5,68(sp)
800091be:	4b06                	lw	s6,64(sp)
800091c0:	5bf2                	lw	s7,60(sp)
800091c2:	5c62                	lw	s8,56(sp)
800091c4:	5cd2                	lw	s9,52(sp)
800091c6:	6125                	addi	sp,sp,96
800091c8:	8082                	ret

Disassembly of section .text.uart_flush:

800091ca <uart_flush>:
{
800091ca:	1101                	addi	sp,sp,-32
800091cc:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
800091ce:	ce02                	sw	zero,28(sp)
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
800091d0:	a811                	j	800091e4 <.L60>

800091d2 <.L63>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
800091d2:	4772                	lw	a4,28(sp)
800091d4:	6785                	lui	a5,0x1
800091d6:	38878793          	addi	a5,a5,904 # 1388 <__NONCACHEABLE_RAM_segment_used_size__+0x2c8>
800091da:	00e7eb63          	bltu	a5,a4,800091f0 <.L66>
        retry++;
800091de:	47f2                	lw	a5,28(sp)
800091e0:	0785                	addi	a5,a5,1
800091e2:	ce3e                	sw	a5,28(sp)

800091e4 <.L60>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
800091e4:	47b2                	lw	a5,12(sp)
800091e6:	5bdc                	lw	a5,52(a5)
800091e8:	0407f793          	andi	a5,a5,64
800091ec:	d3fd                	beqz	a5,800091d2 <.L63>
800091ee:	a011                	j	800091f2 <.L62>

800091f0 <.L66>:
            break;
800091f0:	0001                	nop

800091f2 <.L62>:
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
800091f2:	4772                	lw	a4,28(sp)
800091f4:	6785                	lui	a5,0x1
800091f6:	38878793          	addi	a5,a5,904 # 1388 <__NONCACHEABLE_RAM_segment_used_size__+0x2c8>
800091fa:	00e7f463          	bgeu	a5,a4,80009202 <.L64>
        return status_timeout;
800091fe:	478d                	li	a5,3
80009200:	a011                	j	80009204 <.L65>

80009202 <.L64>:
    return status_success;
80009202:	4781                	li	a5,0

80009204 <.L65>:
}
80009204:	853e                	mv	a0,a5
80009206:	6105                	addi	sp,sp,32
80009208:	8082                	ret

Disassembly of section .text.uart_init_rxline_idle_detection:

8000920a <uart_init_rxline_idle_detection>:
{
8000920a:	1101                	addi	sp,sp,-32
8000920c:	ce06                	sw	ra,28(sp)
8000920e:	c62a                	sw	a0,12(sp)
80009210:	c42e                	sw	a1,8(sp)
    ptr->IDLE_CFG &= ~(UART_IDLE_CFG_RX_IDLE_EN_MASK
80009212:	47b2                	lw	a5,12(sp)
80009214:	43dc                	lw	a5,4(a5)
80009216:	c007f713          	andi	a4,a5,-1024
8000921a:	47b2                	lw	a5,12(sp)
8000921c:	c3d8                	sw	a4,4(a5)
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
8000921e:	47b2                	lw	a5,12(sp)
80009220:	43d8                	lw	a4,4(a5)
80009222:	00814783          	lbu	a5,8(sp)
80009226:	07a2                	slli	a5,a5,0x8
80009228:	1007f793          	andi	a5,a5,256
                    | UART_IDLE_CFG_RX_IDLE_THR_SET(rxidle_config.threshold)
8000922c:	00b14683          	lbu	a3,11(sp)
80009230:	8edd                	or	a3,a3,a5
                    | UART_IDLE_CFG_RX_IDLE_COND_SET(rxidle_config.idle_cond);
80009232:	00a14783          	lbu	a5,10(sp)
80009236:	07a6                	slli	a5,a5,0x9
80009238:	2007f793          	andi	a5,a5,512
8000923c:	8fd5                	or	a5,a5,a3
    ptr->IDLE_CFG |= UART_IDLE_CFG_RX_IDLE_EN_SET(rxidle_config.detect_enable)
8000923e:	8f5d                	or	a4,a4,a5
80009240:	47b2                	lw	a5,12(sp)
80009242:	c3d8                	sw	a4,4(a5)
    if (rxidle_config.detect_irq_enable) {
80009244:	00914783          	lbu	a5,9(sp)
80009248:	c791                	beqz	a5,80009254 <.L93>
        uart_enable_irq(ptr, uart_intr_rx_line_idle);
8000924a:	800005b7          	lui	a1,0x80000
8000924e:	4532                	lw	a0,12(sp)
80009250:	31ad                	jal	80008eba <uart_enable_irq>
80009252:	a029                	j	8000925c <.L94>

80009254 <.L93>:
        uart_disable_irq(ptr, uart_intr_rx_line_idle);
80009254:	800005b7          	lui	a1,0x80000
80009258:	4532                	lw	a0,12(sp)
8000925a:	3191                	jal	80008e9e <uart_disable_irq>

8000925c <.L94>:
    return status_success;
8000925c:	4781                	li	a5,0
}
8000925e:	853e                	mv	a0,a5
80009260:	40f2                	lw	ra,28(sp)
80009262:	6105                	addi	sp,sp,32
80009264:	8082                	ret

Disassembly of section .text.write_pmp_cfg:

80009266 <write_pmp_cfg>:
{
80009266:	1141                	addi	sp,sp,-16
80009268:	c62a                	sw	a0,12(sp)
8000926a:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000926c:	4722                	lw	a4,8(sp)
8000926e:	478d                	li	a5,3
80009270:	04f70163          	beq	a4,a5,800092b2 <.L11>
80009274:	4722                	lw	a4,8(sp)
80009276:	478d                	li	a5,3
80009278:	04e7e163          	bltu	a5,a4,800092ba <.L17>
8000927c:	4722                	lw	a4,8(sp)
8000927e:	4789                	li	a5,2
80009280:	02f70563          	beq	a4,a5,800092aa <.L13>
80009284:	4722                	lw	a4,8(sp)
80009286:	4789                	li	a5,2
80009288:	02e7e963          	bltu	a5,a4,800092ba <.L17>
8000928c:	47a2                	lw	a5,8(sp)
8000928e:	c791                	beqz	a5,8000929a <.L14>
80009290:	4722                	lw	a4,8(sp)
80009292:	4785                	li	a5,1
80009294:	00f70763          	beq	a4,a5,800092a2 <.L15>
        break;
80009298:	a00d                	j	800092ba <.L17>

8000929a <.L14>:
        write_csr(CSR_PMPCFG0, value);
8000929a:	47b2                	lw	a5,12(sp)
8000929c:	3a079073          	csrw	pmpcfg0,a5
        break;
800092a0:	a831                	j	800092bc <.L16>

800092a2 <.L15>:
        write_csr(CSR_PMPCFG1, value);
800092a2:	47b2                	lw	a5,12(sp)
800092a4:	3a179073          	csrw	pmpcfg1,a5
        break;
800092a8:	a811                	j	800092bc <.L16>

800092aa <.L13>:
        write_csr(CSR_PMPCFG2, value);
800092aa:	47b2                	lw	a5,12(sp)
800092ac:	3a279073          	csrw	pmpcfg2,a5
        break;
800092b0:	a031                	j	800092bc <.L16>

800092b2 <.L11>:
        write_csr(CSR_PMPCFG3, value);
800092b2:	47b2                	lw	a5,12(sp)
800092b4:	3a379073          	csrw	pmpcfg3,a5
        break;
800092b8:	a011                	j	800092bc <.L16>

800092ba <.L17>:
        break;
800092ba:	0001                	nop

800092bc <.L16>:
}
800092bc:	0001                	nop
800092be:	0141                	addi	sp,sp,16
800092c0:	8082                	ret

Disassembly of section .text.write_pma_cfg:

800092c2 <write_pma_cfg>:
{
800092c2:	1141                	addi	sp,sp,-16
800092c4:	c62a                	sw	a0,12(sp)
800092c6:	c42e                	sw	a1,8(sp)
    switch (idx) {
800092c8:	4722                	lw	a4,8(sp)
800092ca:	478d                	li	a5,3
800092cc:	04f70163          	beq	a4,a5,8000930e <.L82>
800092d0:	4722                	lw	a4,8(sp)
800092d2:	478d                	li	a5,3
800092d4:	04e7e163          	bltu	a5,a4,80009316 <.L88>
800092d8:	4722                	lw	a4,8(sp)
800092da:	4789                	li	a5,2
800092dc:	02f70563          	beq	a4,a5,80009306 <.L84>
800092e0:	4722                	lw	a4,8(sp)
800092e2:	4789                	li	a5,2
800092e4:	02e7e963          	bltu	a5,a4,80009316 <.L88>
800092e8:	47a2                	lw	a5,8(sp)
800092ea:	c791                	beqz	a5,800092f6 <.L85>
800092ec:	4722                	lw	a4,8(sp)
800092ee:	4785                	li	a5,1
800092f0:	00f70763          	beq	a4,a5,800092fe <.L86>
        break;
800092f4:	a00d                	j	80009316 <.L88>

800092f6 <.L85>:
        write_csr(CSR_PMACFG0, value);
800092f6:	47b2                	lw	a5,12(sp)
800092f8:	bc079073          	csrw	0xbc0,a5
        break;
800092fc:	a831                	j	80009318 <.L87>

800092fe <.L86>:
        write_csr(CSR_PMACFG1, value);
800092fe:	47b2                	lw	a5,12(sp)
80009300:	bc179073          	csrw	0xbc1,a5
        break;
80009304:	a811                	j	80009318 <.L87>

80009306 <.L84>:
        write_csr(CSR_PMACFG2, value);
80009306:	47b2                	lw	a5,12(sp)
80009308:	bc279073          	csrw	0xbc2,a5
        break;
8000930c:	a031                	j	80009318 <.L87>

8000930e <.L82>:
        write_csr(CSR_PMACFG3, value);
8000930e:	47b2                	lw	a5,12(sp)
80009310:	bc379073          	csrw	0xbc3,a5
        break;
80009314:	a011                	j	80009318 <.L87>

80009316 <.L88>:
        break;
80009316:	0001                	nop

80009318 <.L87>:
}
80009318:	0001                	nop
8000931a:	0141                	addi	sp,sp,16
8000931c:	8082                	ret

Disassembly of section .text.pmp_config:

8000931e <pmp_config>:

    return status;
}

hpm_stat_t pmp_config(const pmp_entry_t *entry, uint32_t num_of_entries)
{
8000931e:	7139                	addi	sp,sp,-64
80009320:	de06                	sw	ra,60(sp)
80009322:	c62a                	sw	a0,12(sp)
80009324:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
80009326:	4789                	li	a5,2
80009328:	d63e                	sw	a5,44(sp)
    do {
        HPM_BREAK_IF((entry == NULL) || (num_of_entries < 1U) || (num_of_entries > PMP_ENTRY_MAX));
8000932a:	47b2                	lw	a5,12(sp)
8000932c:	0e078463          	beqz	a5,80009414 <.L142>
80009330:	47a2                	lw	a5,8(sp)
80009332:	c3ed                	beqz	a5,80009414 <.L142>
80009334:	4722                	lw	a4,8(sp)
80009336:	47c1                	li	a5,16
80009338:	0ce7ee63          	bltu	a5,a4,80009414 <.L142>

        status = status_success;
8000933c:	d602                	sw	zero,44(sp)

8000933e <.LBB47>:
        for (uint32_t i = 0; i < num_of_entries; i++) {
8000933e:	d402                	sw	zero,40(sp)
80009340:	a0d1                	j	80009404 <.L143>

80009342 <.L146>:
            uint32_t idx = i / 4;
80009342:	57a2                	lw	a5,40(sp)
80009344:	8389                	srli	a5,a5,0x2
80009346:	d23e                	sw	a5,36(sp)
            uint32_t offset = (i * 8) & 0x1F;
80009348:	57a2                	lw	a5,40(sp)
8000934a:	078e                	slli	a5,a5,0x3
8000934c:	8be1                	andi	a5,a5,24
8000934e:	d03e                	sw	a5,32(sp)
            uint32_t pmp_cfg = read_pmp_cfg(idx);
80009350:	5512                	lw	a0,36(sp)
80009352:	dc1fc0ef          	jal	80006112 <read_pmp_cfg>
80009356:	ce2a                	sw	a0,28(sp)

            /* Check if the PMP entry is locked */
            uint32_t pmpi_cfg = (pmp_cfg & (0xFFUL << offset)) >> offset;
80009358:	5782                	lw	a5,32(sp)
8000935a:	0ff00713          	li	a4,255
8000935e:	00f71733          	sll	a4,a4,a5
80009362:	47f2                	lw	a5,28(sp)
80009364:	8f7d                	and	a4,a4,a5
80009366:	5782                	lw	a5,32(sp)
80009368:	00f757b3          	srl	a5,a4,a5
8000936c:	cc3e                	sw	a5,24(sp)
            if ((pmpi_cfg & PMP_REG_LOCK_MASK) != 0) {
8000936e:	47e2                	lw	a5,24(sp)
80009370:	0807f793          	andi	a5,a5,128
80009374:	c781                	beqz	a5,8000937c <.L144>
                status = status_fail;
80009376:	4785                	li	a5,1
80009378:	d63e                	sw	a5,44(sp)
                break;
8000937a:	a849                	j	8000940c <.L145>

8000937c <.L144>:
            }

            pmp_cfg &= ~(0xFFUL << offset);
8000937c:	5782                	lw	a5,32(sp)
8000937e:	0ff00713          	li	a4,255
80009382:	00f717b3          	sll	a5,a4,a5
80009386:	fff7c793          	not	a5,a5
8000938a:	4772                	lw	a4,28(sp)
8000938c:	8ff9                	and	a5,a5,a4
8000938e:	ce3e                	sw	a5,28(sp)
            pmp_cfg |= ((uint32_t)entry->pmp_cfg.val) << offset;
80009390:	47b2                	lw	a5,12(sp)
80009392:	0007c783          	lbu	a5,0(a5)
80009396:	873e                	mv	a4,a5
80009398:	5782                	lw	a5,32(sp)
8000939a:	00f717b3          	sll	a5,a4,a5
8000939e:	4772                	lw	a4,28(sp)
800093a0:	8fd9                	or	a5,a5,a4
800093a2:	ce3e                	sw	a5,28(sp)
            write_pmp_addr(entry->pmp_addr, i);
800093a4:	47b2                	lw	a5,12(sp)
800093a6:	43dc                	lw	a5,4(a5)
800093a8:	55a2                	lw	a1,40(sp)
800093aa:	853e                	mv	a0,a5
800093ac:	dd5fc0ef          	jal	80006180 <write_pmp_addr>
            write_pmp_cfg(pmp_cfg, idx);
800093b0:	5592                	lw	a1,36(sp)
800093b2:	4572                	lw	a0,28(sp)
800093b4:	3d4d                	jal	80009266 <write_pmp_cfg>
#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
            uint32_t pma_cfg = read_pma_cfg(idx);
800093b6:	5512                	lw	a0,36(sp)
800093b8:	e6ffc0ef          	jal	80006226 <read_pma_cfg>
800093bc:	ca2a                	sw	a0,20(sp)
            pma_cfg &= ~(0xFFUL << offset);
800093be:	5782                	lw	a5,32(sp)
800093c0:	0ff00713          	li	a4,255
800093c4:	00f717b3          	sll	a5,a4,a5
800093c8:	fff7c793          	not	a5,a5
800093cc:	4752                	lw	a4,20(sp)
800093ce:	8ff9                	and	a5,a5,a4
800093d0:	ca3e                	sw	a5,20(sp)
            pma_cfg |= ((uint32_t)entry->pma_cfg.val) << offset;
800093d2:	47b2                	lw	a5,12(sp)
800093d4:	0087c783          	lbu	a5,8(a5)
800093d8:	873e                	mv	a4,a5
800093da:	5782                	lw	a5,32(sp)
800093dc:	00f717b3          	sll	a5,a4,a5
800093e0:	4752                	lw	a4,20(sp)
800093e2:	8fd9                	or	a5,a5,a4
800093e4:	ca3e                	sw	a5,20(sp)
            write_pma_cfg(pma_cfg, idx);
800093e6:	5592                	lw	a1,36(sp)
800093e8:	4552                	lw	a0,20(sp)
800093ea:	3de1                	jal	800092c2 <write_pma_cfg>
            write_pma_addr(entry->pma_addr, i);
800093ec:	47b2                	lw	a5,12(sp)
800093ee:	47dc                	lw	a5,12(a5)
800093f0:	55a2                	lw	a1,40(sp)
800093f2:	853e                	mv	a0,a5
800093f4:	ea1fc0ef          	jal	80006294 <write_pma_addr>
#endif
            ++entry;
800093f8:	47b2                	lw	a5,12(sp)
800093fa:	07c1                	addi	a5,a5,16
800093fc:	c63e                	sw	a5,12(sp)

800093fe <.LBE48>:
        for (uint32_t i = 0; i < num_of_entries; i++) {
800093fe:	57a2                	lw	a5,40(sp)
80009400:	0785                	addi	a5,a5,1
80009402:	d43e                	sw	a5,40(sp)

80009404 <.L143>:
80009404:	5722                	lw	a4,40(sp)
80009406:	47a2                	lw	a5,8(sp)
80009408:	f2f76de3          	bltu	a4,a5,80009342 <.L146>

8000940c <.L145>:
        }

        /* Only call fencei if all entries were configured successfully */
        if (status == status_success) {
8000940c:	57b2                	lw	a5,44(sp)
8000940e:	e399                	bnez	a5,80009414 <.L142>
            fencei();
80009410:	0000100f          	fence.i

80009414 <.L142>:
        }

    } while (false);

    return status;
80009414:	57b2                	lw	a5,44(sp)
}
80009416:	853e                	mv	a0,a5
80009418:	50f2                	lw	ra,60(sp)
8000941a:	6121                	addi	sp,sp,64
8000941c:	8082                	ret

Disassembly of section .text.pllctlv2_pll_clk_is_stable:

8000941e <pllctlv2_pll_clk_is_stable>:
 * @param [in] pll Index of the PLL to check (pllctlv2_pll0 through pllctlv2_pll6)
 * @param [in] clk Post-divider output index (pllctlv2_clk0 through pllctlv2_clk3)
 * @return true if the PLL CLK is stable and locked, false otherwise
 */
static inline bool pllctlv2_pll_clk_is_stable(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
8000941e:	1101                	addi	sp,sp,-32
80009420:	c62a                	sw	a0,12(sp)
80009422:	87ae                	mv	a5,a1
80009424:	8732                	mv	a4,a2
80009426:	00f105a3          	sb	a5,11(sp)
8000942a:	87ba                	mv	a5,a4
8000942c:	00f10523          	sb	a5,10(sp)
    uint32_t status = ptr->PLL[pll].DIV[clk];
80009430:	00b14683          	lbu	a3,11(sp)
80009434:	00a14783          	lbu	a5,10(sp)
80009438:	4732                	lw	a4,12(sp)
8000943a:	0696                	slli	a3,a3,0x5
8000943c:	97b6                	add	a5,a5,a3
8000943e:	03078793          	addi	a5,a5,48
80009442:	078a                	slli	a5,a5,0x2
80009444:	97ba                	add	a5,a5,a4
80009446:	439c                	lw	a5,0(a5)
80009448:	ce3e                	sw	a5,28(sp)
    return (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_DIV_ENABLE_MASK)
8000944a:	4772                	lw	a4,28(sp)
8000944c:	100007b7          	lui	a5,0x10000
80009450:	8ff9                	and	a5,a5,a4
         || (IS_HPM_BITMASK_CLR(status, PLLCTLV2_PLL_DIV_BUSY_MASK) && IS_HPM_BITMASK_SET(status, PLLCTLV2_PLL_DIV_RESPONSE_MASK)));
80009452:	cb89                	beqz	a5,80009464 <.L7>
80009454:	47f2                	lw	a5,28(sp)
80009456:	0007c963          	bltz	a5,80009468 <.L8>
8000945a:	4772                	lw	a4,28(sp)
8000945c:	200007b7          	lui	a5,0x20000
80009460:	8ff9                	and	a5,a5,a4
80009462:	c399                	beqz	a5,80009468 <.L8>

80009464 <.L7>:
80009464:	4785                	li	a5,1
80009466:	a011                	j	8000946a <.L9>

80009468 <.L8>:
80009468:	4781                	li	a5,0

8000946a <.L9>:
8000946a:	8b85                	andi	a5,a5,1
8000946c:	0ff7f793          	zext.b	a5,a5
}
80009470:	853e                	mv	a0,a5
80009472:	6105                	addi	sp,sp,32
80009474:	8082                	ret

Disassembly of section .text.pllctlv2_set_postdiv:

80009476 <pllctlv2_set_postdiv>:
        ptr->PLL[pll].CONFIG |= PLLCTLV2_PLL_CONFIG_SPREAD_MASK;
    }
}

void pllctlv2_set_postdiv(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk, pllctlv2_div_t div_value)
{
80009476:	1101                	addi	sp,sp,-32
80009478:	ce06                	sw	ra,28(sp)
8000947a:	c62a                	sw	a0,12(sp)
8000947c:	87ae                	mv	a5,a1
8000947e:	8736                	mv	a4,a3
80009480:	00f105a3          	sb	a5,11(sp)
80009484:	87b2                	mv	a5,a2
80009486:	00f10523          	sb	a5,10(sp)
8000948a:	87ba                	mv	a5,a4
8000948c:	00f104a3          	sb	a5,9(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
80009490:	47b2                	lw	a5,12(sp)
80009492:	c7ad                	beqz	a5,800094fc <.L32>
80009494:	00b14703          	lbu	a4,11(sp)
80009498:	4789                	li	a5,2
8000949a:	06e7e163          	bltu	a5,a4,800094fc <.L32>
        ptr->PLL[pll].DIV[clk] =
            (ptr->PLL[pll].DIV[clk] & ~PLLCTLV2_PLL_DIV_DIV_MASK) | PLLCTLV2_PLL_DIV_DIV_SET(div_value);
8000949e:	00b14683          	lbu	a3,11(sp)
800094a2:	00a14783          	lbu	a5,10(sp)
800094a6:	4732                	lw	a4,12(sp)
800094a8:	0696                	slli	a3,a3,0x5
800094aa:	97b6                	add	a5,a5,a3
800094ac:	03078793          	addi	a5,a5,48 # 20000030 <__NONCACHEABLE_RAM_segment_end__+0x1edc0030>
800094b0:	078a                	slli	a5,a5,0x2
800094b2:	97ba                	add	a5,a5,a4
800094b4:	439c                	lw	a5,0(a5)
800094b6:	fc07f693          	andi	a3,a5,-64
800094ba:	00914783          	lbu	a5,9(sp)
800094be:	03f7f713          	andi	a4,a5,63
        ptr->PLL[pll].DIV[clk] =
800094c2:	00b14603          	lbu	a2,11(sp)
800094c6:	00a14783          	lbu	a5,10(sp)
            (ptr->PLL[pll].DIV[clk] & ~PLLCTLV2_PLL_DIV_DIV_MASK) | PLLCTLV2_PLL_DIV_DIV_SET(div_value);
800094ca:	8f55                	or	a4,a4,a3
        ptr->PLL[pll].DIV[clk] =
800094cc:	46b2                	lw	a3,12(sp)
800094ce:	0616                	slli	a2,a2,0x5
800094d0:	97b2                	add	a5,a5,a2
800094d2:	03078793          	addi	a5,a5,48
800094d6:	078a                	slli	a5,a5,0x2
800094d8:	97b6                	add	a5,a5,a3
800094da:	c398                	sw	a4,0(a5)

        while (!pllctlv2_pll_clk_is_stable(ptr, pll, clk)) {
800094dc:	a011                	j	800094e0 <.L30>

800094de <.L31>:
            NOP();
800094de:	0001                	nop

800094e0 <.L30>:
        while (!pllctlv2_pll_clk_is_stable(ptr, pll, clk)) {
800094e0:	00a14703          	lbu	a4,10(sp)
800094e4:	00b14783          	lbu	a5,11(sp)
800094e8:	863a                	mv	a2,a4
800094ea:	85be                	mv	a1,a5
800094ec:	4532                	lw	a0,12(sp)
800094ee:	3f05                	jal	8000941e <pllctlv2_pll_clk_is_stable>
800094f0:	87aa                	mv	a5,a0
800094f2:	0017c793          	xori	a5,a5,1
800094f6:	0ff7f793          	zext.b	a5,a5
800094fa:	f3f5                	bnez	a5,800094de <.L31>

800094fc <.L32>:
        }
    }
}
800094fc:	0001                	nop
800094fe:	40f2                	lw	ra,28(sp)
80009500:	6105                	addi	sp,sp,32
80009502:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_freq_in_hz:

80009504 <pllctlv2_get_pll_freq_in_hz>:

uint32_t pllctlv2_get_pll_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll)
{
80009504:	7139                	addi	sp,sp,-64
80009506:	de06                	sw	ra,60(sp)
80009508:	c62a                	sw	a0,12(sp)
8000950a:	87ae                	mv	a5,a1
8000950c:	00f105a3          	sb	a5,11(sp)
    uint32_t freq = 0;
80009510:	d602                	sw	zero,44(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
80009512:	47b2                	lw	a5,12(sp)
80009514:	12078963          	beqz	a5,80009646 <.L34>
80009518:	00b14703          	lbu	a4,11(sp)
8000951c:	4789                	li	a5,2
8000951e:	12e7e463          	bltu	a5,a4,80009646 <.L34>

80009522 <.LBB3>:
        uint32_t mfi = PLLCTLV2_PLL_MFI_MFI_GET(ptr->PLL[pll].MFI);
80009522:	00b14783          	lbu	a5,11(sp)
80009526:	4732                	lw	a4,12(sp)
80009528:	0785                	addi	a5,a5,1
8000952a:	079e                	slli	a5,a5,0x7
8000952c:	97ba                	add	a5,a5,a4
8000952e:	439c                	lw	a5,0(a5)
80009530:	07f7f793          	andi	a5,a5,127
80009534:	d23e                	sw	a5,36(sp)
        uint32_t mfn = PLLCTLV2_PLL_MFN_MFN_GET(ptr->PLL[pll].MFN);
80009536:	00b14783          	lbu	a5,11(sp)
8000953a:	4732                	lw	a4,12(sp)
8000953c:	0785                	addi	a5,a5,1
8000953e:	079e                	slli	a5,a5,0x7
80009540:	97ba                	add	a5,a5,a4
80009542:	43d8                	lw	a4,4(a5)
80009544:	400007b7          	lui	a5,0x40000
80009548:	17fd                	addi	a5,a5,-1 # 3fffffff <__NONCACHEABLE_RAM_segment_end__+0x3edbffff>
8000954a:	8ff9                	and	a5,a5,a4
8000954c:	d03e                	sw	a5,32(sp)
        uint32_t mfd = PLLCTLV2_PLL_MFD_MFD_GET(ptr->PLL[pll].MFD);
8000954e:	00b14783          	lbu	a5,11(sp)
80009552:	4732                	lw	a4,12(sp)
80009554:	0785                	addi	a5,a5,1
80009556:	079e                	slli	a5,a5,0x7
80009558:	97ba                	add	a5,a5,a4
8000955a:	4798                	lw	a4,8(a5)
8000955c:	400007b7          	lui	a5,0x40000
80009560:	17fd                	addi	a5,a5,-1 # 3fffffff <__NONCACHEABLE_RAM_segment_end__+0x3edbffff>
80009562:	8ff9                	and	a5,a5,a4
80009564:	ce3e                	sw	a5,28(sp)
        /* Trade-off for avoiding the float computing.
         * Ensure both `mfd` and `PLLCTLV2_PLL_XTAL_FREQ` are n * `FREQ_1MHz`, n is a positive integer
         */
        assert((mfd / FREQ_1MHz) * FREQ_1MHz == mfd);
80009566:	4772                	lw	a4,28(sp)
80009568:	431be7b7          	lui	a5,0x431be
8000956c:	e8378793          	addi	a5,a5,-381 # 431bde83 <__NONCACHEABLE_RAM_segment_end__+0x41f7de83>
80009570:	02f737b3          	mulhu	a5,a4,a5
80009574:	83c9                	srli	a5,a5,0x12
80009576:	000f46b7          	lui	a3,0xf4
8000957a:	24068693          	addi	a3,a3,576 # f4240 <__AXI_SRAM_segment_size__+0xc4240>
8000957e:	02d787b3          	mul	a5,a5,a3
80009582:	40f707b3          	sub	a5,a4,a5
80009586:	cb89                	beqz	a5,80009598 <.L35>
80009588:	06f00613          	li	a2,111
8000958c:	23818593          	addi	a1,gp,568 # 8000436c <.LC0>
80009590:	27418513          	addi	a0,gp,628 # 800043a8 <.LC1>
80009594:	a38fd0ef          	jal	800067cc <__SEGGER_RTL_X_assert>

80009598 <.L35>:
        assert((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * FREQ_1MHz == PLLCTLV2_PLL_XTAL_FREQ);

        uint32_t scaled_num;
        uint32_t scaled_denom;
        uint32_t shifted_mfn;
        uint32_t max_mfn = 0xFFFFFFFF / (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz);
80009598:	0aaab7b7          	lui	a5,0xaaab
8000959c:	aaa78793          	addi	a5,a5,-1366 # aaaaaaa <__NONCACHEABLE_RAM_segment_end__+0x986aaaa>
800095a0:	cc3e                	sw	a5,24(sp)
        if (mfn < max_mfn) {
800095a2:	5702                	lw	a4,32(sp)
800095a4:	47e2                	lw	a5,24(sp)
800095a6:	02f77f63          	bgeu	a4,a5,800095e4 <.L36>
            scaled_num =  (PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * mfn;
800095aa:	5702                	lw	a4,32(sp)
800095ac:	87ba                	mv	a5,a4
800095ae:	0786                	slli	a5,a5,0x1
800095b0:	97ba                	add	a5,a5,a4
800095b2:	078e                	slli	a5,a5,0x3
800095b4:	c83e                	sw	a5,16(sp)
            scaled_denom = mfd / FREQ_1MHz;
800095b6:	4772                	lw	a4,28(sp)
800095b8:	431be7b7          	lui	a5,0x431be
800095bc:	e8378793          	addi	a5,a5,-381 # 431bde83 <__NONCACHEABLE_RAM_segment_end__+0x41f7de83>
800095c0:	02f737b3          	mulhu	a5,a4,a5
800095c4:	83c9                	srli	a5,a5,0x12
800095c6:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + scaled_num / scaled_denom;
800095c8:	5712                	lw	a4,36(sp)
800095ca:	016e37b7          	lui	a5,0x16e3
800095ce:	60078793          	addi	a5,a5,1536 # 16e3600 <__NONCACHEABLE_RAM_segment_end__+0x4a3600>
800095d2:	02f70733          	mul	a4,a4,a5
800095d6:	46c2                	lw	a3,16(sp)
800095d8:	47d2                	lw	a5,20(sp)
800095da:	02f6d7b3          	divu	a5,a3,a5
800095de:	97ba                	add	a5,a5,a4
800095e0:	d63e                	sw	a5,44(sp)
800095e2:	a095                	j	80009646 <.L34>

800095e4 <.L36>:
        } else {
            shifted_mfn = mfn;
800095e4:	5782                	lw	a5,32(sp)
800095e6:	d43e                	sw	a5,40(sp)
            while (shifted_mfn > max_mfn) {
800095e8:	a021                	j	800095f0 <.L37>

800095ea <.L38>:
                shifted_mfn >>= 1;
800095ea:	57a2                	lw	a5,40(sp)
800095ec:	8385                	srli	a5,a5,0x1
800095ee:	d43e                	sw	a5,40(sp)

800095f0 <.L37>:
            while (shifted_mfn > max_mfn) {
800095f0:	5722                	lw	a4,40(sp)
800095f2:	47e2                	lw	a5,24(sp)
800095f4:	fee7ebe3          	bltu	a5,a4,800095ea <.L38>
            }
            scaled_denom = mfd / FREQ_1MHz;
800095f8:	4772                	lw	a4,28(sp)
800095fa:	431be7b7          	lui	a5,0x431be
800095fe:	e8378793          	addi	a5,a5,-381 # 431bde83 <__NONCACHEABLE_RAM_segment_end__+0x41f7de83>
80009602:	02f737b3          	mulhu	a5,a4,a5
80009606:	83c9                	srli	a5,a5,0x12
80009608:	ca3e                	sw	a5,20(sp)
            freq = PLLCTLV2_PLL_XTAL_FREQ * mfi + ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * shifted_mfn) / scaled_denom +  ((PLLCTLV2_PLL_XTAL_FREQ / FREQ_1MHz) * (mfn - shifted_mfn)) / scaled_denom;
8000960a:	5712                	lw	a4,36(sp)
8000960c:	016e37b7          	lui	a5,0x16e3
80009610:	60078793          	addi	a5,a5,1536 # 16e3600 <__NONCACHEABLE_RAM_segment_end__+0x4a3600>
80009614:	02f706b3          	mul	a3,a4,a5
80009618:	5722                	lw	a4,40(sp)
8000961a:	87ba                	mv	a5,a4
8000961c:	0786                	slli	a5,a5,0x1
8000961e:	97ba                	add	a5,a5,a4
80009620:	078e                	slli	a5,a5,0x3
80009622:	873e                	mv	a4,a5
80009624:	47d2                	lw	a5,20(sp)
80009626:	02f757b3          	divu	a5,a4,a5
8000962a:	96be                	add	a3,a3,a5
8000962c:	5702                	lw	a4,32(sp)
8000962e:	57a2                	lw	a5,40(sp)
80009630:	8f1d                	sub	a4,a4,a5
80009632:	87ba                	mv	a5,a4
80009634:	0786                	slli	a5,a5,0x1
80009636:	97ba                	add	a5,a5,a4
80009638:	078e                	slli	a5,a5,0x3
8000963a:	873e                	mv	a4,a5
8000963c:	47d2                	lw	a5,20(sp)
8000963e:	02f757b3          	divu	a5,a4,a5
80009642:	97b6                	add	a5,a5,a3
80009644:	d63e                	sw	a5,44(sp)

80009646 <.L34>:
        }
    }
    return freq;
80009646:	57b2                	lw	a5,44(sp)
}
80009648:	853e                	mv	a0,a5
8000964a:	50f2                	lw	ra,60(sp)
8000964c:	6121                	addi	sp,sp,64
8000964e:	8082                	ret

Disassembly of section .text.pllctlv2_get_pll_postdiv_freq_in_hz:

80009650 <pllctlv2_get_pll_postdiv_freq_in_hz>:

uint32_t pllctlv2_get_pll_postdiv_freq_in_hz(PLLCTLV2_Type *ptr, pllctlv2_pll_t pll, pllctlv2_clk_t clk)
{
80009650:	7179                	addi	sp,sp,-48
80009652:	d606                	sw	ra,44(sp)
80009654:	c62a                	sw	a0,12(sp)
80009656:	87ae                	mv	a5,a1
80009658:	8732                	mv	a4,a2
8000965a:	00f105a3          	sb	a5,11(sp)
8000965e:	87ba                	mv	a5,a4
80009660:	00f10523          	sb	a5,10(sp)
    uint32_t postdiv_freq = 0;
80009664:	ce02                	sw	zero,28(sp)
    if ((ptr != NULL) && (pll < PLLCTL_SOC_PLL_MAX_COUNT)) {
80009666:	47b2                	lw	a5,12(sp)
80009668:	cba5                	beqz	a5,800096d8 <.L41>
8000966a:	00b14703          	lbu	a4,11(sp)
8000966e:	4789                	li	a5,2
80009670:	06e7e463          	bltu	a5,a4,800096d8 <.L41>

80009674 <.LBB4>:
        uint32_t postdiv = PLLCTLV2_PLL_DIV_DIV_GET(ptr->PLL[pll].DIV[clk]);
80009674:	00b14683          	lbu	a3,11(sp)
80009678:	00a14783          	lbu	a5,10(sp)
8000967c:	4732                	lw	a4,12(sp)
8000967e:	0696                	slli	a3,a3,0x5
80009680:	97b6                	add	a5,a5,a3
80009682:	03078793          	addi	a5,a5,48
80009686:	078a                	slli	a5,a5,0x2
80009688:	97ba                	add	a5,a5,a4
8000968a:	439c                	lw	a5,0(a5)
8000968c:	03f7f793          	andi	a5,a5,63
80009690:	cc3e                	sw	a5,24(sp)
        uint32_t pll_freq = pllctlv2_get_pll_freq_in_hz(ptr, pll);
80009692:	00b14783          	lbu	a5,11(sp)
80009696:	85be                	mv	a1,a5
80009698:	4532                	lw	a0,12(sp)
8000969a:	35ad                	jal	80009504 <pllctlv2_get_pll_freq_in_hz>
8000969c:	ca2a                	sw	a0,20(sp)
        postdiv_freq = (uint32_t) (pll_freq / (100 + postdiv * 100 / 5U) * 100);
8000969e:	4762                	lw	a4,24(sp)
800096a0:	87ba                	mv	a5,a4
800096a2:	078a                	slli	a5,a5,0x2
800096a4:	97ba                	add	a5,a5,a4
800096a6:	00279713          	slli	a4,a5,0x2
800096aa:	97ba                	add	a5,a5,a4
800096ac:	078a                	slli	a5,a5,0x2
800096ae:	873e                	mv	a4,a5
800096b0:	ccccd7b7          	lui	a5,0xccccd
800096b4:	ccd78793          	addi	a5,a5,-819 # cccccccd <__FLASH_segment_end__+0x4cbccccd>
800096b8:	02f737b3          	mulhu	a5,a4,a5
800096bc:	8389                	srli	a5,a5,0x2
800096be:	06478793          	addi	a5,a5,100
800096c2:	4752                	lw	a4,20(sp)
800096c4:	02f75733          	divu	a4,a4,a5
800096c8:	87ba                	mv	a5,a4
800096ca:	078a                	slli	a5,a5,0x2
800096cc:	97ba                	add	a5,a5,a4
800096ce:	00279713          	slli	a4,a5,0x2
800096d2:	97ba                	add	a5,a5,a4
800096d4:	078a                	slli	a5,a5,0x2
800096d6:	ce3e                	sw	a5,28(sp)

800096d8 <.L41>:
    }

    return postdiv_freq;
800096d8:	47f2                	lw	a5,28(sp)
}
800096da:	853e                	mv	a0,a5
800096dc:	50b2                	lw	ra,44(sp)
800096de:	6145                	addi	sp,sp,48
800096e0:	8082                	ret

Disassembly of section .text.adc16_get_channel_default_config:

800096e2 <adc16_get_channel_default_config>:

void adc16_get_channel_default_config(adc16_channel_config_t *config)
{
800096e2:	1141                	addi	sp,sp,-16
800096e4:	c62a                	sw	a0,12(sp)
    config->ch                 = 0;
800096e6:	47b2                	lw	a5,12(sp)
800096e8:	00078023          	sb	zero,0(a5)
    config->sample_cycle       = 10;
800096ec:	47b2                	lw	a5,12(sp)
800096ee:	4729                	li	a4,10
800096f0:	c798                	sw	a4,8(a5)
    config->sample_cycle_shift = 0;
800096f2:	47b2                	lw	a5,12(sp)
800096f4:	000783a3          	sb	zero,7(a5)
    config->thshdh             = 0xffff;
800096f8:	47b2                	lw	a5,12(sp)
800096fa:	577d                	li	a4,-1
800096fc:	00e79123          	sh	a4,2(a5)
    config->thshdl             = 0x0000;
80009700:	47b2                	lw	a5,12(sp)
80009702:	00079223          	sh	zero,4(a5)
    config->wdog_int_en        = false;
80009706:	47b2                	lw	a5,12(sp)
80009708:	00078323          	sb	zero,6(a5)
}
8000970c:	0001                	nop
8000970e:	0141                	addi	sp,sp,16
80009710:	8082                	ret

Disassembly of section .text.adc16_do_calibration:

80009712 <adc16_do_calibration>:

static hpm_stat_t adc16_do_calibration(ADC16_Type *ptr)
{
80009712:	7155                	addi	sp,sp,-208
80009714:	c786                	sw	ra,204(sp)
80009716:	c62a                	sw	a0,12(sp)
    uint64_t param64;
    uint32_t param32;
    uint32_t temp;

    /* Get input clock divider */
    clk_div_temp = ADC16_CONV_CFG1_CLOCK_DIVIDER_GET(ptr->CONV_CFG1);
80009718:	4532                	lw	a0,12(sp)
8000971a:	6585                	lui	a1,0x1
8000971c:	95aa                	add	a1,a1,a0
8000971e:	1045a583          	lw	a1,260(a1) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>
80009722:	89bd                	andi	a1,a1,15
80009724:	db2e                	sw	a1,180(sp)

    /* Set input clock divider temporarily */
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
80009726:	4532                	lw	a0,12(sp)
80009728:	6585                	lui	a1,0x1
8000972a:	95aa                	add	a1,a1,a0
8000972c:	1045a583          	lw	a1,260(a1) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>
80009730:	99c1                	andi	a1,a1,-16
                   | ADC16_CONV_CFG1_CLOCK_DIVIDER_SET(1);
80009732:	0015e513          	ori	a0,a1,1
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
80009736:	4332                	lw	t1,12(sp)
80009738:	6585                	lui	a1,0x1
8000973a:	959a                	add	a1,a1,t1
8000973c:	10a5a223          	sw	a0,260(a1) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>

    /* Enable ADC config clock */
    ptr->ANA_CTRL0 |= ADC16_ANA_CTRL0_ADC_CLK_ON_MASK;
80009740:	4532                	lw	a0,12(sp)
80009742:	6585                	lui	a1,0x1
80009744:	95aa                	add	a1,a1,a0
80009746:	2005a503          	lw	a0,512(a1) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>
8000974a:	6585                	lui	a1,0x1
8000974c:	8d4d                	or	a0,a0,a1
8000974e:	4332                	lw	t1,12(sp)
80009750:	6585                	lui	a1,0x1
80009752:	959a                	add	a1,a1,t1
80009754:	20a5a023          	sw	a0,512(a1) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>

    for (i = 0; i < ADC16_SOC_PARAMS_LEN; i++) {
80009758:	df02                	sw	zero,188(sp)
8000975a:	a811                	j	8000976e <.L4>

8000975c <.L5>:
        adc16_params[i] = 0;
8000975c:	557a                	lw	a0,188(sp)
8000975e:	080c                	addi	a1,sp,16
80009760:	050a                	slli	a0,a0,0x2
80009762:	95aa                	add	a1,a1,a0
80009764:	0005a023          	sw	zero,0(a1)
    for (i = 0; i < ADC16_SOC_PARAMS_LEN; i++) {
80009768:	55fa                	lw	a1,188(sp)
8000976a:	0585                	addi	a1,a1,1
8000976c:	df2e                	sw	a1,188(sp)

8000976e <.L4>:
8000976e:	557a                	lw	a0,188(sp)
80009770:	02100593          	li	a1,33
80009774:	fea5f4e3          	bgeu	a1,a0,8000975c <.L5>
    }

    /* Enable reg_en */
    /* Enable bandgap_en */
    ptr->ADC16_CONFIG0 |= ADC16_ADC16_CONFIG0_REG_EN_MASK
80009778:	4532                	lw	a0,12(sp)
8000977a:	6585                	lui	a1,0x1
8000977c:	95aa                	add	a1,a1,a0
8000977e:	4445a503          	lw	a0,1092(a1) # 1444 <__NONCACHEABLE_RAM_segment_used_size__+0x384>
80009782:	018005b7          	lui	a1,0x1800
80009786:	8d4d                	or	a0,a0,a1
80009788:	4332                	lw	t1,12(sp)
8000978a:	6585                	lui	a1,0x1
8000978c:	959a                	add	a1,a1,t1
8000978e:	44a5a223          	sw	a0,1092(a1) # 1444 <__NONCACHEABLE_RAM_segment_used_size__+0x384>
                       |  ADC16_ADC16_CONFIG0_BANDGAP_EN_MASK;

    /* Set cal_avg_cfg for 32 loops */
    ptr->ADC16_CONFIG0 = (ptr->ADC16_CONFIG0 & ~ADC16_ADC16_CONFIG0_CAL_AVG_CFG_MASK)
80009792:	4532                	lw	a0,12(sp)
80009794:	6585                	lui	a1,0x1
80009796:	95aa                	add	a1,a1,a0
80009798:	4445a503          	lw	a0,1092(a1) # 1444 <__NONCACHEABLE_RAM_segment_used_size__+0x384>
8000979c:	ff9005b7          	lui	a1,0xff900
800097a0:	15fd                	addi	a1,a1,-1 # ff8fffff <__AHB_SRAM_segment_end__+0xf6f7fff>
800097a2:	8d6d                	and	a0,a0,a1
                       | ADC16_ADC16_CONFIG0_CAL_AVG_CFG_SET(5);
800097a4:	005005b7          	lui	a1,0x500
800097a8:	8d4d                	or	a0,a0,a1
    ptr->ADC16_CONFIG0 = (ptr->ADC16_CONFIG0 & ~ADC16_ADC16_CONFIG0_CAL_AVG_CFG_MASK)
800097aa:	4332                	lw	t1,12(sp)
800097ac:	6585                	lui	a1,0x1
800097ae:	959a                	add	a1,a1,t1
800097b0:	44a5a223          	sw	a0,1092(a1) # 1444 <__NONCACHEABLE_RAM_segment_used_size__+0x384>

    /* Enable ahb_en */
    ptr->ADC_CFG0 |= ADC16_ADC_CFG0_ADC_AHB_EN_MASK | (1 << 2);
800097b4:	4532                	lw	a0,12(sp)
800097b6:	6585                	lui	a1,0x1
800097b8:	95aa                	add	a1,a1,a0
800097ba:	1085a503          	lw	a0,264(a1) # 1108 <__NONCACHEABLE_RAM_segment_used_size__+0x48>
800097be:	200005b7          	lui	a1,0x20000
800097c2:	0591                	addi	a1,a1,4 # 20000004 <__NONCACHEABLE_RAM_segment_end__+0x1edc0004>
800097c4:	8d4d                	or	a0,a0,a1
800097c6:	4332                	lw	t1,12(sp)
800097c8:	6585                	lui	a1,0x1
800097ca:	959a                	add	a1,a1,t1
800097cc:	10a5a423          	sw	a0,264(a1) # 1108 <__NONCACHEABLE_RAM_segment_used_size__+0x48>

    /* Disable ADC config clock */
    ptr->ANA_CTRL0 &= ~ADC16_ANA_CTRL0_ADC_CLK_ON_MASK;
800097d0:	4532                	lw	a0,12(sp)
800097d2:	6585                	lui	a1,0x1
800097d4:	95aa                	add	a1,a1,a0
800097d6:	2005a503          	lw	a0,512(a1) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>
800097da:	75fd                	lui	a1,0xfffff
800097dc:	15fd                	addi	a1,a1,-1 # ffffefff <__AHB_SRAM_segment_end__+0xfdf6fff>
800097de:	8d6d                	and	a0,a0,a1
800097e0:	4332                	lw	t1,12(sp)
800097e2:	6585                	lui	a1,0x1
800097e4:	959a                	add	a1,a1,t1
800097e6:	20a5a023          	sw	a0,512(a1) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>

    /* Recover input clock divider */
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
800097ea:	4532                	lw	a0,12(sp)
800097ec:	6585                	lui	a1,0x1
800097ee:	95aa                	add	a1,a1,a0
800097f0:	1045a583          	lw	a1,260(a1) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>
800097f4:	ff05f513          	andi	a0,a1,-16
                   | ADC16_CONV_CFG1_CLOCK_DIVIDER_SET(clk_div_temp);
800097f8:	55da                	lw	a1,180(sp)
800097fa:	89bd                	andi	a1,a1,15
800097fc:	8d4d                	or	a0,a0,a1
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
800097fe:	4332                	lw	t1,12(sp)
80009800:	6585                	lui	a1,0x1
80009802:	959a                	add	a1,a1,t1
80009804:	10a5a223          	sw	a0,260(a1) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>

    for (j = 0; j < 4; j++) {
80009808:	dd02                	sw	zero,184(sp)
8000980a:	a841                	j	8000989a <.L6>

8000980c <.L10>:
        /* Set startcal */
        ptr->ANA_CTRL0 |= ADC16_ANA_CTRL0_STARTCAL_MASK;
8000980c:	4532                	lw	a0,12(sp)
8000980e:	6585                	lui	a1,0x1
80009810:	95aa                	add	a1,a1,a0
80009812:	2005a583          	lw	a1,512(a1) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>
80009816:	0045e513          	ori	a0,a1,4
8000981a:	4332                	lw	t1,12(sp)
8000981c:	6585                	lui	a1,0x1
8000981e:	959a                	add	a1,a1,t1
80009820:	20a5a023          	sw	a0,512(a1) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>

        /* Clear startcal */
        ptr->ANA_CTRL0 &= ~ADC16_ANA_CTRL0_STARTCAL_MASK;
80009824:	4532                	lw	a0,12(sp)
80009826:	6585                	lui	a1,0x1
80009828:	95aa                	add	a1,a1,a0
8000982a:	2005a583          	lw	a1,512(a1) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>
8000982e:	ffb5f513          	andi	a0,a1,-5
80009832:	4332                	lw	t1,12(sp)
80009834:	6585                	lui	a1,0x1
80009836:	959a                	add	a1,a1,t1
80009838:	20a5a023          	sw	a0,512(a1) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>

        /* Polling calibration status */
        while (ADC16_ANA_STATUS_CALON_GET(ptr->ANA_STATUS)) {
8000983c:	0001                	nop

8000983e <.L7>:
8000983e:	4532                	lw	a0,12(sp)
80009840:	6585                	lui	a1,0x1
80009842:	95aa                	add	a1,a1,a0
80009844:	2105a583          	lw	a1,528(a1) # 1210 <__NONCACHEABLE_RAM_segment_used_size__+0x150>
80009848:	0805f593          	andi	a1,a1,128
8000984c:	f9ed                	bnez	a1,8000983e <.L7>
        }

        /* Read parameters */
        for (i = 0; i < ADC16_SOC_PARAMS_LEN; i++) {
8000984e:	df02                	sw	zero,188(sp)
80009850:	a82d                	j	8000988a <.L8>

80009852 <.L9>:
            adc16_params[i] += ADC16_ADC16_PARAMS_PARAM_VAL_GET(ptr->ADC16_PARAMS[i]);
80009852:	4532                	lw	a0,12(sp)
80009854:	537a                	lw	t1,188(sp)
80009856:	6585                	lui	a1,0x1
80009858:	a0058593          	addi	a1,a1,-1536 # a00 <__ILM_segment_used_end__+0x3e2>
8000985c:	959a                	add	a1,a1,t1
8000985e:	0586                	slli	a1,a1,0x1
80009860:	95aa                	add	a1,a1,a0
80009862:	0005d583          	lhu	a1,0(a1)
80009866:	0805c5b3          	zext.h	a1,a1
8000986a:	832e                	mv	t1,a1
8000986c:	557a                	lw	a0,188(sp)
8000986e:	080c                	addi	a1,sp,16
80009870:	050a                	slli	a0,a0,0x2
80009872:	95aa                	add	a1,a1,a0
80009874:	418c                	lw	a1,0(a1)
80009876:	00b30533          	add	a0,t1,a1
8000987a:	537a                	lw	t1,188(sp)
8000987c:	080c                	addi	a1,sp,16
8000987e:	030a                	slli	t1,t1,0x2
80009880:	959a                	add	a1,a1,t1
80009882:	c188                	sw	a0,0(a1)
        for (i = 0; i < ADC16_SOC_PARAMS_LEN; i++) {
80009884:	55fa                	lw	a1,188(sp)
80009886:	0585                	addi	a1,a1,1
80009888:	df2e                	sw	a1,188(sp)

8000988a <.L8>:
8000988a:	557a                	lw	a0,188(sp)
8000988c:	02100593          	li	a1,33
80009890:	fca5f1e3          	bgeu	a1,a0,80009852 <.L9>
    for (j = 0; j < 4; j++) {
80009894:	55ea                	lw	a1,184(sp)
80009896:	0585                	addi	a1,a1,1
80009898:	dd2e                	sw	a1,184(sp)

8000989a <.L6>:
8000989a:	556a                	lw	a0,184(sp)
8000989c:	458d                	li	a1,3
8000989e:	f6a5f7e3          	bgeu	a1,a0,8000980c <.L10>
        }
    }

    adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA33] -= 0x800;
800098a2:	45da                	lw	a1,148(sp)
800098a4:	80058593          	addi	a1,a1,-2048
800098a8:	cb2e                	sw	a1,148(sp)
    param01 = adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA32] - adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA33];
800098aa:	454a                	lw	a0,144(sp)
800098ac:	45da                	lw	a1,148(sp)
800098ae:	40b505b3          	sub	a1,a0,a1
800098b2:	d92e                	sw	a1,176(sp)
    adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA32] = adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA00] -
800098b4:	4542                	lw	a0,16(sp)
                                                    adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA33];
800098b6:	45da                	lw	a1,148(sp)
    adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA32] = adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA00] -
800098b8:	40b505b3          	sub	a1,a0,a1
800098bc:	c92e                	sw	a1,144(sp)
    adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA00] = 0;
800098be:	c802                	sw	zero,16(sp)

    for (i = 1; i < ADC16_SOC_PARAMS_LEN - 2; i++) {
800098c0:	4585                	li	a1,1
800098c2:	df2e                	sw	a1,188(sp)
800098c4:	a815                	j	800098f8 <.L11>

800098c6 <.L12>:
        adc16_params[i] = adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA32] + adc16_params[i] -
800098c6:	454a                	lw	a0,144(sp)
800098c8:	537a                	lw	t1,188(sp)
800098ca:	080c                	addi	a1,sp,16
800098cc:	030a                	slli	t1,t1,0x2
800098ce:	959a                	add	a1,a1,t1
800098d0:	418c                	lw	a1,0(a1)
800098d2:	952e                	add	a0,a0,a1
                          adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA33] + adc16_params[i - 1];
800098d4:	45da                	lw	a1,148(sp)
        adc16_params[i] = adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA32] + adc16_params[i] -
800098d6:	8d0d                	sub	a0,a0,a1
                          adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA33] + adc16_params[i - 1];
800098d8:	55fa                	lw	a1,188(sp)
800098da:	fff58313          	addi	t1,a1,-1
800098de:	080c                	addi	a1,sp,16
800098e0:	030a                	slli	t1,t1,0x2
800098e2:	959a                	add	a1,a1,t1
800098e4:	418c                	lw	a1,0(a1)
800098e6:	952e                	add	a0,a0,a1
        adc16_params[i] = adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA32] + adc16_params[i] -
800098e8:	537a                	lw	t1,188(sp)
800098ea:	080c                	addi	a1,sp,16
800098ec:	030a                	slli	t1,t1,0x2
800098ee:	959a                	add	a1,a1,t1
800098f0:	c188                	sw	a0,0(a1)
    for (i = 1; i < ADC16_SOC_PARAMS_LEN - 2; i++) {
800098f2:	55fa                	lw	a1,188(sp)
800098f4:	0585                	addi	a1,a1,1
800098f6:	df2e                	sw	a1,188(sp)

800098f8 <.L11>:
800098f8:	557a                	lw	a0,188(sp)
800098fa:	45fd                	li	a1,31
800098fc:	fca5f5e3          	bgeu	a1,a0,800098c6 <.L12>
    }

    param02 = (param01 + adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA31] + adc16_params[ADC16_ADC16_PARAMS_ADC16_PARA32]) >> 6;
80009900:	453a                	lw	a0,140(sp)
80009902:	55ca                	lw	a1,176(sp)
80009904:	952e                	add	a0,a0,a1
80009906:	45ca                	lw	a1,144(sp)
80009908:	95aa                	add	a1,a1,a0
8000990a:	8199                	srli	a1,a1,0x6
8000990c:	d72e                	sw	a1,172(sp)
    param64 = 0x10000ll * param02;
8000990e:	55ba                	lw	a1,172(sp)
80009910:	862e                	mv	a2,a1
80009912:	4681                	li	a3,0
80009914:	01065593          	srli	a1,a2,0x10
80009918:	01069793          	slli	a5,a3,0x10
8000991c:	8fcd                	or	a5,a5,a1
8000991e:	01061713          	slli	a4,a2,0x10
80009922:	d13a                	sw	a4,160(sp)
80009924:	d33e                	sw	a5,164(sp)
    param64 = param64 / (0x20000 - param02 / 2);
80009926:	57ba                	lw	a5,172(sp)
80009928:	8385                	srli	a5,a5,0x1
8000992a:	00020737          	lui	a4,0x20
8000992e:	40f707b3          	sub	a5,a4,a5
80009932:	883e                	mv	a6,a5
80009934:	4881                	li	a7,0
80009936:	8642                	mv	a2,a6
80009938:	86c6                	mv	a3,a7
8000993a:	550a                	lw	a0,160(sp)
8000993c:	559a                	lw	a1,164(sp)
8000993e:	3a1000ef          	jal	8000a4de <__udivdi3>
80009942:	872a                	mv	a4,a0
80009944:	87ae                	mv	a5,a1
80009946:	d13a                	sw	a4,160(sp)
80009948:	d33e                	sw	a5,164(sp)
    param32 = (uint32_t)param64;
8000994a:	578a                	lw	a5,160(sp)
8000994c:	cf3e                	sw	a5,156(sp)

    for (i = 0; i < ADC16_SOC_PARAMS_LEN; i++) {
8000994e:	df02                	sw	zero,188(sp)
80009950:	a005                	j	80009970 <.L13>

80009952 <.L14>:
        adc16_params[i] >>= 6;
80009952:	577a                	lw	a4,188(sp)
80009954:	081c                	addi	a5,sp,16
80009956:	070a                	slli	a4,a4,0x2
80009958:	97ba                	add	a5,a5,a4
8000995a:	439c                	lw	a5,0(a5)
8000995c:	0067d713          	srli	a4,a5,0x6
80009960:	56fa                	lw	a3,188(sp)
80009962:	081c                	addi	a5,sp,16
80009964:	068a                	slli	a3,a3,0x2
80009966:	97b6                	add	a5,a5,a3
80009968:	c398                	sw	a4,0(a5)
    for (i = 0; i < ADC16_SOC_PARAMS_LEN; i++) {
8000996a:	57fa                	lw	a5,188(sp)
8000996c:	0785                	addi	a5,a5,1
8000996e:	df3e                	sw	a5,188(sp)

80009970 <.L13>:
80009970:	577a                	lw	a4,188(sp)
80009972:	02100793          	li	a5,33
80009976:	fce7fee3          	bgeu	a5,a4,80009952 <.L14>
    }

    /* Enable ADC config clock */
    ptr->ANA_CTRL0 |= ADC16_ANA_CTRL0_ADC_CLK_ON_MASK;
8000997a:	4732                	lw	a4,12(sp)
8000997c:	6785                	lui	a5,0x1
8000997e:	97ba                	add	a5,a5,a4
80009980:	2007a703          	lw	a4,512(a5) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>
80009984:	6785                	lui	a5,0x1
80009986:	8f5d                	or	a4,a4,a5
80009988:	46b2                	lw	a3,12(sp)
8000998a:	6785                	lui	a5,0x1
8000998c:	97b6                	add	a5,a5,a3
8000998e:	20e7a023          	sw	a4,512(a5) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>

    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
80009992:	4732                	lw	a4,12(sp)
80009994:	6785                	lui	a5,0x1
80009996:	97ba                	add	a5,a5,a4
80009998:	1047a783          	lw	a5,260(a5) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>
8000999c:	9bc1                	andi	a5,a5,-16
                   | ADC16_CONV_CFG1_CLOCK_DIVIDER_SET(1);
8000999e:	0017e713          	ori	a4,a5,1
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
800099a2:	46b2                	lw	a3,12(sp)
800099a4:	6785                	lui	a5,0x1
800099a6:	97b6                	add	a5,a5,a3
800099a8:	10e7a223          	sw	a4,260(a5) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>

    /* Write parameters */
    for (i = 0; i < ADC16_SOC_PARAMS_LEN ; i++) {
800099ac:	df02                	sw	zero,188(sp)
800099ae:	a02d                	j	800099d8 <.L15>

800099b0 <.L16>:
        ptr->ADC16_PARAMS[i] = (uint16_t)(adc16_params[i]);
800099b0:	577a                	lw	a4,188(sp)
800099b2:	081c                	addi	a5,sp,16
800099b4:	070a                	slli	a4,a4,0x2
800099b6:	97ba                	add	a5,a5,a4
800099b8:	439c                	lw	a5,0(a5)
800099ba:	0807c733          	zext.h	a4,a5
800099be:	46b2                	lw	a3,12(sp)
800099c0:	567a                	lw	a2,188(sp)
800099c2:	6785                	lui	a5,0x1
800099c4:	a0078793          	addi	a5,a5,-1536 # a00 <__ILM_segment_used_end__+0x3e2>
800099c8:	97b2                	add	a5,a5,a2
800099ca:	0786                	slli	a5,a5,0x1
800099cc:	97b6                	add	a5,a5,a3
800099ce:	00e79023          	sh	a4,0(a5)
    for (i = 0; i < ADC16_SOC_PARAMS_LEN ; i++) {
800099d2:	57fa                	lw	a5,188(sp)
800099d4:	0785                	addi	a5,a5,1
800099d6:	df3e                	sw	a5,188(sp)

800099d8 <.L15>:
800099d8:	577a                	lw	a4,188(sp)
800099da:	02100793          	li	a5,33
800099de:	fce7f9e3          	bgeu	a5,a4,800099b0 <.L16>
    }

    /* Set ADC16 Config0 */
    temp = ptr->ADC16_CONFIG0;
800099e2:	4732                	lw	a4,12(sp)
800099e4:	6785                	lui	a5,0x1
800099e6:	97ba                	add	a5,a5,a4
800099e8:	4447a783          	lw	a5,1092(a5) # 1444 <__NONCACHEABLE_RAM_segment_used_size__+0x384>
800099ec:	cd3e                	sw	a5,152(sp)

    temp &= ~(ADC16_ADC16_CONFIG0_CAL_AVG_CFG_MASK | ADC16_ADC16_CONFIG0_CONV_PARAM_MASK);
800099ee:	476a                	lw	a4,152(sp)
800099f0:	ff8fc7b7          	lui	a5,0xff8fc
800099f4:	8ff9                	and	a5,a5,a4
800099f6:	cd3e                	sw	a5,152(sp)

    temp |= ADC16_ADC16_CONFIG0_REG_EN_MASK
         |  ADC16_ADC16_CONFIG0_BANDGAP_EN_MASK
         |  ADC16_ADC16_CONFIG0_CAL_AVG_CFG_MASK
         |  ADC16_ADC16_CONFIG0_CONV_PARAM_SET(param32);
800099f8:	477a                	lw	a4,156(sp)
800099fa:	6791                	lui	a5,0x4
800099fc:	17fd                	addi	a5,a5,-1 # 3fff <__BOOT_HEADER_segment_size__+0x1fff>
800099fe:	8f7d                	and	a4,a4,a5
    temp |= ADC16_ADC16_CONFIG0_REG_EN_MASK
80009a00:	47ea                	lw	a5,152(sp)
80009a02:	8f5d                	or	a4,a4,a5
80009a04:	01f007b7          	lui	a5,0x1f00
80009a08:	8fd9                	or	a5,a5,a4
80009a0a:	cd3e                	sw	a5,152(sp)

    ptr->ADC16_CONFIG0 = temp;
80009a0c:	4732                	lw	a4,12(sp)
80009a0e:	6785                	lui	a5,0x1
80009a10:	97ba                	add	a5,a5,a4
80009a12:	476a                	lw	a4,152(sp)
80009a14:	44e7a223          	sw	a4,1092(a5) # 1444 <__NONCACHEABLE_RAM_segment_used_size__+0x384>

    /* Recover input clock divider */
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
80009a18:	4732                	lw	a4,12(sp)
80009a1a:	6785                	lui	a5,0x1
80009a1c:	97ba                	add	a5,a5,a4
80009a1e:	1047a783          	lw	a5,260(a5) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>
80009a22:	ff07f713          	andi	a4,a5,-16
                   | ADC16_CONV_CFG1_CLOCK_DIVIDER_SET(clk_div_temp);
80009a26:	57da                	lw	a5,180(sp)
80009a28:	8bbd                	andi	a5,a5,15
80009a2a:	8f5d                	or	a4,a4,a5
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
80009a2c:	46b2                	lw	a3,12(sp)
80009a2e:	6785                	lui	a5,0x1
80009a30:	97b6                	add	a5,a5,a3
80009a32:	10e7a223          	sw	a4,260(a5) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>

    /* Disable ADC config clock */
    ptr->ANA_CTRL0 &= ~ADC16_ANA_CTRL0_ADC_CLK_ON_MASK;
80009a36:	4732                	lw	a4,12(sp)
80009a38:	6785                	lui	a5,0x1
80009a3a:	97ba                	add	a5,a5,a4
80009a3c:	2007a703          	lw	a4,512(a5) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>
80009a40:	77fd                	lui	a5,0xfffff
80009a42:	17fd                	addi	a5,a5,-1 # ffffefff <__AHB_SRAM_segment_end__+0xfdf6fff>
80009a44:	8f7d                	and	a4,a4,a5
80009a46:	46b2                	lw	a3,12(sp)
80009a48:	6785                	lui	a5,0x1
80009a4a:	97b6                	add	a5,a5,a3
80009a4c:	20e7a023          	sw	a4,512(a5) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>

    return status_success;
80009a50:	4781                	li	a5,0
}
80009a52:	853e                	mv	a0,a5
80009a54:	40be                	lw	ra,204(sp)
80009a56:	6169                	addi	sp,sp,208
80009a58:	8082                	ret

Disassembly of section .text.adc16_init:

80009a5a <adc16_init>:

    return status_success;
}

hpm_stat_t adc16_init(ADC16_Type *ptr, adc16_config_t *config)
{
80009a5a:	7179                	addi	sp,sp,-48
80009a5c:	d606                	sw	ra,44(sp)
80009a5e:	c62a                	sw	a0,12(sp)
80009a60:	c42e                	sw	a1,8(sp)
    uint32_t clk_div_temp;

    /* Set convert clock number and clock period */
    if (config->adc_clk_div - 1 > ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)  {
80009a62:	47a2                	lw	a5,8(sp)
80009a64:	43dc                	lw	a5,4(a5)
80009a66:	fff78713          	addi	a4,a5,-1
80009a6a:	47bd                	li	a5,15
80009a6c:	00e7f463          	bgeu	a5,a4,80009a74 <.L21>
        return status_invalid_argument;
80009a70:	4789                	li	a5,2
80009a72:	a21d                	j	80009b98 <.L22>

80009a74 <.L21>:
    }

    /* Set ADC minimum conversion cycle and ADC clock divider */
    ptr->CONV_CFG1 = ADC16_CONV_CFG1_CONVERT_CLOCK_NUMBER_SET(config->res)
80009a74:	47a2                	lw	a5,8(sp)
80009a76:	0007c783          	lbu	a5,0(a5)
80009a7a:	0792                	slli	a5,a5,0x4
80009a7c:	1f07f713          	andi	a4,a5,496
                   | ADC16_CONV_CFG1_CLOCK_DIVIDER_SET(config->adc_clk_div - 1);
80009a80:	47a2                	lw	a5,8(sp)
80009a82:	43dc                	lw	a5,4(a5)
80009a84:	17fd                	addi	a5,a5,-1
80009a86:	8bbd                	andi	a5,a5,15
80009a88:	8f5d                	or	a4,a4,a5
    ptr->CONV_CFG1 = ADC16_CONV_CFG1_CONVERT_CLOCK_NUMBER_SET(config->res)
80009a8a:	46b2                	lw	a3,12(sp)
80009a8c:	6785                	lui	a5,0x1
80009a8e:	97b6                	add	a5,a5,a3
80009a90:	10e7a223          	sw	a4,260(a5) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>

    /* Set ahb_en */
    /* Set the duration of the conversion */
    ptr->ADC_CFG0 = ADC16_ADC_CFG0_SEL_SYNC_AHB_SET(config->sel_sync_ahb)
80009a94:	47a2                	lw	a5,8(sp)
80009a96:	00a7c783          	lbu	a5,10(a5)
80009a9a:	01f79713          	slli	a4,a5,0x1f
                  | ADC16_ADC_CFG0_ADC_AHB_EN_SET(config->adc_ahb_en)
80009a9e:	47a2                	lw	a5,8(sp)
80009aa0:	00b7c783          	lbu	a5,11(a5)
80009aa4:	01d79693          	slli	a3,a5,0x1d
80009aa8:	200007b7          	lui	a5,0x20000
80009aac:	8ff5                	and	a5,a5,a3
80009aae:	8fd9                	or	a5,a5,a4
                  | ADC16_ADC_CFG0_PORT3_REALTIME_SET(config->port3_realtime);
80009ab0:	4722                	lw	a4,8(sp)
80009ab2:	00874703          	lbu	a4,8(a4) # 20008 <__DLM_segment_size__+0x8>
80009ab6:	8f5d                	or	a4,a4,a5
    ptr->ADC_CFG0 = ADC16_ADC_CFG0_SEL_SYNC_AHB_SET(config->sel_sync_ahb)
80009ab8:	46b2                	lw	a3,12(sp)
80009aba:	6785                	lui	a5,0x1
80009abc:	97b6                	add	a5,a5,a3
80009abe:	10e7a423          	sw	a4,264(a5) # 1108 <__NONCACHEABLE_RAM_segment_used_size__+0x48>

    /* Set wait_dis */
    ptr->BUF_CFG0 = ADC16_BUF_CFG0_WAIT_DIS_SET(config->wait_dis);
80009ac2:	47a2                	lw	a5,8(sp)
80009ac4:	0097c783          	lbu	a5,9(a5)
80009ac8:	873e                	mv	a4,a5
80009aca:	47b2                	lw	a5,12(sp)
80009acc:	50e7a023          	sw	a4,1280(a5)

    /* Get input clock divider */
    clk_div_temp = ADC16_CONV_CFG1_CLOCK_DIVIDER_GET(ptr->CONV_CFG1);
80009ad0:	4732                	lw	a4,12(sp)
80009ad2:	6785                	lui	a5,0x1
80009ad4:	97ba                	add	a5,a5,a4
80009ad6:	1047a783          	lw	a5,260(a5) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>
80009ada:	8bbd                	andi	a5,a5,15
80009adc:	ce3e                	sw	a5,28(sp)

    /* Set input clock divider temporarily */
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
80009ade:	4732                	lw	a4,12(sp)
80009ae0:	6785                	lui	a5,0x1
80009ae2:	97ba                	add	a5,a5,a4
80009ae4:	1047a783          	lw	a5,260(a5) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>
80009ae8:	9bc1                	andi	a5,a5,-16
                   | ADC16_CONV_CFG1_CLOCK_DIVIDER_SET(1);
80009aea:	0017e713          	ori	a4,a5,1
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
80009aee:	46b2                	lw	a3,12(sp)
80009af0:	6785                	lui	a5,0x1
80009af2:	97b6                	add	a5,a5,a3
80009af4:	10e7a223          	sw	a4,260(a5) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>

    /* Enable ADC config clock */
    ptr->ANA_CTRL0 |= ADC16_ANA_CTRL0_ADC_CLK_ON_MASK;
80009af8:	4732                	lw	a4,12(sp)
80009afa:	6785                	lui	a5,0x1
80009afc:	97ba                	add	a5,a5,a4
80009afe:	2007a703          	lw	a4,512(a5) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>
80009b02:	6785                	lui	a5,0x1
80009b04:	8f5d                	or	a4,a4,a5
80009b06:	46b2                	lw	a3,12(sp)
80009b08:	6785                	lui	a5,0x1
80009b0a:	97b6                	add	a5,a5,a3
80009b0c:	20e7a023          	sw	a4,512(a5) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>

    /* Set end count */
    ptr->ADC16_CONFIG1 &= ~ADC16_ADC16_CONFIG1_COV_END_CNT_MASK;
80009b10:	4732                	lw	a4,12(sp)
80009b12:	6785                	lui	a5,0x1
80009b14:	97ba                	add	a5,a5,a4
80009b16:	4607a703          	lw	a4,1120(a5) # 1460 <__NONCACHEABLE_RAM_segment_used_size__+0x3a0>
80009b1a:	77f9                	lui	a5,0xffffe
80009b1c:	0ff78793          	addi	a5,a5,255 # ffffe0ff <__AHB_SRAM_segment_end__+0xfdf60ff>
80009b20:	8f7d                	and	a4,a4,a5
80009b22:	46b2                	lw	a3,12(sp)
80009b24:	6785                	lui	a5,0x1
80009b26:	97b6                	add	a5,a5,a3
80009b28:	46e7a023          	sw	a4,1120(a5) # 1460 <__NONCACHEABLE_RAM_segment_used_size__+0x3a0>
    ptr->ADC16_CONFIG1 |= ADC16_ADC16_CONFIG1_COV_END_CNT_SET(ADC16_SOC_MAX_CONV_CLK_NUM - config->res + 1);
80009b2c:	4732                	lw	a4,12(sp)
80009b2e:	6785                	lui	a5,0x1
80009b30:	97ba                	add	a5,a5,a4
80009b32:	4607a703          	lw	a4,1120(a5) # 1460 <__NONCACHEABLE_RAM_segment_used_size__+0x3a0>
80009b36:	47a2                	lw	a5,8(sp)
80009b38:	0007c783          	lbu	a5,0(a5)
80009b3c:	86be                	mv	a3,a5
80009b3e:	47d9                	li	a5,22
80009b40:	8f95                	sub	a5,a5,a3
80009b42:	00879693          	slli	a3,a5,0x8
80009b46:	6789                	lui	a5,0x2
80009b48:	f0078793          	addi	a5,a5,-256 # 1f00 <__NONCACHEABLE_RAM_segment_used_size__+0xe40>
80009b4c:	8ff5                	and	a5,a5,a3
80009b4e:	8f5d                	or	a4,a4,a5
80009b50:	46b2                	lw	a3,12(sp)
80009b52:	6785                	lui	a5,0x1
80009b54:	97b6                	add	a5,a5,a3
80009b56:	46e7a023          	sw	a4,1120(a5) # 1460 <__NONCACHEABLE_RAM_segment_used_size__+0x3a0>

    /* Disable ADC config clock */
    ptr->ANA_CTRL0 &= ~ADC16_ANA_CTRL0_ADC_CLK_ON_MASK;
80009b5a:	4732                	lw	a4,12(sp)
80009b5c:	6785                	lui	a5,0x1
80009b5e:	97ba                	add	a5,a5,a4
80009b60:	2007a703          	lw	a4,512(a5) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>
80009b64:	77fd                	lui	a5,0xfffff
80009b66:	17fd                	addi	a5,a5,-1 # ffffefff <__AHB_SRAM_segment_end__+0xfdf6fff>
80009b68:	8f7d                	and	a4,a4,a5
80009b6a:	46b2                	lw	a3,12(sp)
80009b6c:	6785                	lui	a5,0x1
80009b6e:	97b6                	add	a5,a5,a3
80009b70:	20e7a023          	sw	a4,512(a5) # 1200 <__NONCACHEABLE_RAM_segment_used_size__+0x140>

    /* Recover input clock divider */
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
80009b74:	4732                	lw	a4,12(sp)
80009b76:	6785                	lui	a5,0x1
80009b78:	97ba                	add	a5,a5,a4
80009b7a:	1047a783          	lw	a5,260(a5) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>
80009b7e:	ff07f713          	andi	a4,a5,-16
                   | ADC16_CONV_CFG1_CLOCK_DIVIDER_SET(clk_div_temp);
80009b82:	47f2                	lw	a5,28(sp)
80009b84:	8bbd                	andi	a5,a5,15
80009b86:	8f5d                	or	a4,a4,a5
    ptr->CONV_CFG1 = (ptr->CONV_CFG1 & ~ADC16_CONV_CFG1_CLOCK_DIVIDER_MASK)
80009b88:	46b2                	lw	a3,12(sp)
80009b8a:	6785                	lui	a5,0x1
80009b8c:	97b6                	add	a5,a5,a3
80009b8e:	10e7a223          	sw	a4,260(a5) # 1104 <__NONCACHEABLE_RAM_segment_used_size__+0x44>

    /* Do a calibration */
    adc16_do_calibration(ptr);
80009b92:	4532                	lw	a0,12(sp)
80009b94:	3ebd                	jal	80009712 <adc16_do_calibration>

    return status_success;
80009b96:	4781                	li	a5,0

80009b98 <.L22>:
}
80009b98:	853e                	mv	a0,a5
80009b9a:	50b2                	lw	ra,44(sp)
80009b9c:	6145                	addi	sp,sp,48
80009b9e:	8082                	ret

Disassembly of section .text.adc16_init_channel:

80009ba0 <adc16_init_channel>:

hpm_stat_t adc16_init_channel(ADC16_Type *ptr, adc16_channel_config_t *config)
{
80009ba0:	1141                	addi	sp,sp,-16
80009ba2:	c62a                	sw	a0,12(sp)
80009ba4:	c42e                	sw	a1,8(sp)
    /* Check the specified channel number */
    if (ADC16_IS_CHANNEL_INVALID(config->ch)) {
80009ba6:	47a2                	lw	a5,8(sp)
80009ba8:	0007c703          	lbu	a4,0(a5)
80009bac:	47bd                	li	a5,15
80009bae:	00e7f463          	bgeu	a5,a4,80009bb6 <.L24>
        return status_invalid_argument;
80009bb2:	4789                	li	a5,2
80009bb4:	a849                	j	80009c46 <.L25>

80009bb6 <.L24>:
    }

    /* Check sample cycle */
    if (ADC16_IS_CHANNEL_SAMPLE_CYCLE_INVALID(config->sample_cycle)) {
80009bb6:	47a2                	lw	a5,8(sp)
80009bb8:	479c                	lw	a5,8(a5)
80009bba:	e399                	bnez	a5,80009bc0 <.L26>
        return status_invalid_argument;
80009bbc:	4789                	li	a5,2
80009bbe:	a061                	j	80009c46 <.L25>

80009bc0 <.L26>:
    }

    /* Set warning threshold */
    ptr->PRD_CFG[config->ch].PRD_THSHD_CFG = ADC16_PRD_CFG_PRD_THSHD_CFG_THSHDH_SET(config->thshdh)
80009bc0:	47a2                	lw	a5,8(sp)
80009bc2:	0027d783          	lhu	a5,2(a5)
80009bc6:	07c2                	slli	a5,a5,0x10
                                           | ADC16_PRD_CFG_PRD_THSHD_CFG_THSHDL_SET(config->thshdl);
80009bc8:	4722                	lw	a4,8(sp)
80009bca:	00475703          	lhu	a4,4(a4)
80009bce:	86ba                	mv	a3,a4
    ptr->PRD_CFG[config->ch].PRD_THSHD_CFG = ADC16_PRD_CFG_PRD_THSHD_CFG_THSHDH_SET(config->thshdh)
80009bd0:	4722                	lw	a4,8(sp)
80009bd2:	00074703          	lbu	a4,0(a4)
80009bd6:	863a                	mv	a2,a4
                                           | ADC16_PRD_CFG_PRD_THSHD_CFG_THSHDL_SET(config->thshdl);
80009bd8:	00d7e733          	or	a4,a5,a3
    ptr->PRD_CFG[config->ch].PRD_THSHD_CFG = ADC16_PRD_CFG_PRD_THSHD_CFG_THSHDH_SET(config->thshdh)
80009bdc:	46b2                	lw	a3,12(sp)
80009bde:	0c060793          	addi	a5,a2,192
80009be2:	0792                	slli	a5,a5,0x4
80009be4:	97b6                	add	a5,a5,a3
80009be6:	c3d8                	sw	a4,4(a5)

    /* Set ADC sample cycles multiple */
    /* Set ADC sample cycles */
    ptr->SAMPLE_CFG[config->ch] = ADC16_SAMPLE_CFG_SAMPLE_CLOCK_NUMBER_SHIFT_SET(config->sample_cycle_shift)
80009be8:	47a2                	lw	a5,8(sp)
80009bea:	0077c783          	lbu	a5,7(a5)
80009bee:	00979713          	slli	a4,a5,0x9
80009bf2:	6785                	lui	a5,0x1
80009bf4:	e0078793          	addi	a5,a5,-512 # e00 <__NOR_CFG_OPTION_segment_size__+0x200>
80009bf8:	8f7d                	and	a4,a4,a5
                                | ADC16_SAMPLE_CFG_SAMPLE_CLOCK_NUMBER_SET(config->sample_cycle);
80009bfa:	47a2                	lw	a5,8(sp)
80009bfc:	479c                	lw	a5,8(a5)
80009bfe:	1ff7f793          	andi	a5,a5,511
    ptr->SAMPLE_CFG[config->ch] = ADC16_SAMPLE_CFG_SAMPLE_CLOCK_NUMBER_SHIFT_SET(config->sample_cycle_shift)
80009c02:	46a2                	lw	a3,8(sp)
80009c04:	0006c683          	lbu	a3,0(a3)
80009c08:	8636                	mv	a2,a3
                                | ADC16_SAMPLE_CFG_SAMPLE_CLOCK_NUMBER_SET(config->sample_cycle);
80009c0a:	8f5d                	or	a4,a4,a5
    ptr->SAMPLE_CFG[config->ch] = ADC16_SAMPLE_CFG_SAMPLE_CLOCK_NUMBER_SHIFT_SET(config->sample_cycle_shift)
80009c0c:	46b2                	lw	a3,12(sp)
80009c0e:	40060793          	addi	a5,a2,1024
80009c12:	078a                	slli	a5,a5,0x2
80009c14:	97b6                	add	a5,a5,a3
80009c16:	c398                	sw	a4,0(a5)

    /* Enable watchdog interrupt */
    if (config->wdog_int_en) {
80009c18:	47a2                	lw	a5,8(sp)
80009c1a:	0067c783          	lbu	a5,6(a5)
80009c1e:	c39d                	beqz	a5,80009c44 <.L27>
        ptr->INT_EN |= 1 << config->ch;
80009c20:	4732                	lw	a4,12(sp)
80009c22:	6785                	lui	a5,0x1
80009c24:	97ba                	add	a5,a5,a4
80009c26:	1147a783          	lw	a5,276(a5) # 1114 <__NONCACHEABLE_RAM_segment_used_size__+0x54>
80009c2a:	4722                	lw	a4,8(sp)
80009c2c:	00074703          	lbu	a4,0(a4)
80009c30:	86ba                	mv	a3,a4
80009c32:	4705                	li	a4,1
80009c34:	00d71733          	sll	a4,a4,a3
80009c38:	8f5d                	or	a4,a4,a5
80009c3a:	46b2                	lw	a3,12(sp)
80009c3c:	6785                	lui	a5,0x1
80009c3e:	97b6                	add	a5,a5,a3
80009c40:	10e7aa23          	sw	a4,276(a5) # 1114 <__NONCACHEABLE_RAM_segment_used_size__+0x54>

80009c44 <.L27>:
    }

    return status_success;
80009c44:	4781                	li	a5,0

80009c46 <.L25>:
}
80009c46:	853e                	mv	a0,a5
80009c48:	0141                	addi	sp,sp,16
80009c4a:	8082                	ret

Disassembly of section .text.adc16_set_pmt_config:

80009c4c <adc16_set_pmt_config>:

    return status_success;
}

hpm_stat_t adc16_set_pmt_config(ADC16_Type *ptr, adc16_pmt_config_t *config)
{
80009c4c:	1101                	addi	sp,sp,-32
80009c4e:	c62a                	sw	a0,12(sp)
80009c50:	c42e                	sw	a1,8(sp)
    uint32_t temp = 0;
80009c52:	ce02                	sw	zero,28(sp)

    /* Check the specified trigger length */
    if (ADC16_IS_TRIG_LEN_INVLAID(config->trig_len)) {
80009c54:	47a2                	lw	a5,8(sp)
80009c56:	0097c703          	lbu	a4,9(a5)
80009c5a:	4791                	li	a5,4
80009c5c:	00e7f463          	bgeu	a5,a4,80009c64 <.L60>
        return status_invalid_argument;
80009c60:	4789                	li	a5,2
80009c62:	a851                	j	80009cf6 <.L61>

80009c64 <.L60>:
    }

    /* Check the trigger channel */
    if (ADC16_IS_TRIG_CH_INVLAID(config->trig_ch)) {
80009c64:	47a2                	lw	a5,8(sp)
80009c66:	0087c703          	lbu	a4,8(a5)
80009c6a:	47ad                	li	a5,11
80009c6c:	00e7f463          	bgeu	a5,a4,80009c74 <.L62>
        return status_invalid_argument;
80009c70:	4789                	li	a5,2
80009c72:	a051                	j	80009cf6 <.L61>

80009c74 <.L62>:
    }

    temp |= ADC16_CONFIG_TRIG_LEN_SET(config->trig_len - 1);
80009c74:	47a2                	lw	a5,8(sp)
80009c76:	0097c783          	lbu	a5,9(a5)
80009c7a:	17fd                	addi	a5,a5,-1
80009c7c:	07fa                	slli	a5,a5,0x1e
80009c7e:	4772                	lw	a4,28(sp)
80009c80:	8fd9                	or	a5,a5,a4
80009c82:	ce3e                	sw	a5,28(sp)

80009c84 <.LBB3>:

    for (int i = 0; i < config->trig_len; i++) {
80009c84:	cc02                	sw	zero,24(sp)
80009c86:	a881                	j	80009cd6 <.L63>

80009c88 <.L65>:
        if (ADC16_IS_CHANNEL_INVALID(config->adc_ch[i])) {
80009c88:	4722                	lw	a4,8(sp)
80009c8a:	47e2                	lw	a5,24(sp)
80009c8c:	97ba                	add	a5,a5,a4
80009c8e:	0047c703          	lbu	a4,4(a5)
80009c92:	47bd                	li	a5,15
80009c94:	00e7f463          	bgeu	a5,a4,80009c9c <.L64>
            return status_invalid_argument;
80009c98:	4789                	li	a5,2
80009c9a:	a8b1                	j	80009cf6 <.L61>

80009c9c <.L64>:
        }

        temp |= config->inten[i] << (ADC16_CONFIG_INTEN0_SHIFT + i * ADC_SOC_CONFIG_INTEN_CHAN_BIT_SIZE)
80009c9c:	4722                	lw	a4,8(sp)
80009c9e:	47e2                	lw	a5,24(sp)
80009ca0:	97ba                	add	a5,a5,a4
80009ca2:	0007c783          	lbu	a5,0(a5)
80009ca6:	873e                	mv	a4,a5
80009ca8:	47e2                	lw	a5,24(sp)
80009caa:	078e                	slli	a5,a5,0x3
80009cac:	0795                	addi	a5,a5,5
80009cae:	00f71733          	sll	a4,a4,a5
             |  config->adc_ch[i] << (ADC16_CONFIG_CHAN0_SHIFT + i * ADC_SOC_CONFIG_INTEN_CHAN_BIT_SIZE);
80009cb2:	46a2                	lw	a3,8(sp)
80009cb4:	47e2                	lw	a5,24(sp)
80009cb6:	97b6                	add	a5,a5,a3
80009cb8:	0047c783          	lbu	a5,4(a5)
80009cbc:	86be                	mv	a3,a5
80009cbe:	47e2                	lw	a5,24(sp)
80009cc0:	078e                	slli	a5,a5,0x3
80009cc2:	00f697b3          	sll	a5,a3,a5
80009cc6:	8fd9                	or	a5,a5,a4
80009cc8:	873e                	mv	a4,a5
        temp |= config->inten[i] << (ADC16_CONFIG_INTEN0_SHIFT + i * ADC_SOC_CONFIG_INTEN_CHAN_BIT_SIZE)
80009cca:	47f2                	lw	a5,28(sp)
80009ccc:	8fd9                	or	a5,a5,a4
80009cce:	ce3e                	sw	a5,28(sp)
    for (int i = 0; i < config->trig_len; i++) {
80009cd0:	47e2                	lw	a5,24(sp)
80009cd2:	0785                	addi	a5,a5,1
80009cd4:	cc3e                	sw	a5,24(sp)

80009cd6 <.L63>:
80009cd6:	47a2                	lw	a5,8(sp)
80009cd8:	0097c783          	lbu	a5,9(a5)
80009cdc:	873e                	mv	a4,a5
80009cde:	47e2                	lw	a5,24(sp)
80009ce0:	fae7c4e3          	blt	a5,a4,80009c88 <.L65>

80009ce4 <.LBE3>:
    }

    ptr->CONFIG[config->trig_ch] = temp;
80009ce4:	47a2                	lw	a5,8(sp)
80009ce6:	0087c783          	lbu	a5,8(a5)
80009cea:	4732                	lw	a4,12(sp)
80009cec:	078a                	slli	a5,a5,0x2
80009cee:	97ba                	add	a5,a5,a4
80009cf0:	4772                	lw	a4,28(sp)
80009cf2:	c398                	sw	a4,0(a5)

    return status_success;
80009cf4:	4781                	li	a5,0

80009cf6 <.L61>:
}
80009cf6:	853e                	mv	a0,a5
80009cf8:	6105                	addi	sp,sp,32
80009cfa:	8082                	ret

Disassembly of section .text.adc16_enable_pmt_queue:

80009cfc <adc16_enable_pmt_queue>:
    return status_success;
#endif
}

hpm_stat_t adc16_enable_pmt_queue(ADC16_Type *ptr, uint8_t trig_ch)
{
80009cfc:	1141                	addi	sp,sp,-16
80009cfe:	c62a                	sw	a0,12(sp)
80009d00:	87ae                	mv	a5,a1
80009d02:	00f105a3          	sb	a5,11(sp)
    (void) ptr;
    /* Check the specified trigger channel */
    if (ADC16_IS_TRIG_CH_INVLAID(trig_ch)) {
80009d06:	00b14703          	lbu	a4,11(sp)
80009d0a:	47ad                	li	a5,11
80009d0c:	00e7f463          	bgeu	a5,a4,80009d14 <.L70>
        return status_invalid_argument;
80009d10:	4789                	li	a5,2
80009d12:	a005                	j	80009d32 <.L71>

80009d14 <.L70>:
    }

#if defined(ADC_SOC_PREEMPT_ENABLE_CTRL_SUPPORT) && ADC_SOC_PREEMPT_ENABLE_CTRL_SUPPORT
    /* Set queue enable control */
    ptr->CONFIG[trig_ch] |= ADC16_CONFIG_QUEUE_EN_MASK;
80009d14:	00b14783          	lbu	a5,11(sp)
80009d18:	4732                	lw	a4,12(sp)
80009d1a:	078a                	slli	a5,a5,0x2
80009d1c:	97ba                	add	a5,a5,a4
80009d1e:	4398                	lw	a4,0(a5)
80009d20:	00b14783          	lbu	a5,11(sp)
80009d24:	04076713          	ori	a4,a4,64
80009d28:	46b2                	lw	a3,12(sp)
80009d2a:	078a                	slli	a5,a5,0x2
80009d2c:	97b6                	add	a5,a5,a3
80009d2e:	c398                	sw	a4,0(a5)
#endif

    return status_success;
80009d30:	4781                	li	a5,0

80009d32 <.L71>:
}
80009d32:	853e                	mv	a0,a5
80009d34:	0141                	addi	sp,sp,16
80009d36:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

80009d38 <pcfg_dcdc_set_voltage>:
{
80009d38:	1101                	addi	sp,sp,-32
80009d3a:	c62a                	sw	a0,12(sp)
80009d3c:	87ae                	mv	a5,a1
80009d3e:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
80009d42:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
80009d44:	00a15703          	lhu	a4,10(sp)
80009d48:	25700793          	li	a5,599
80009d4c:	00e7f863          	bgeu	a5,a4,80009d5c <.L26>
80009d50:	00a15703          	lhu	a4,10(sp)
80009d54:	55f00793          	li	a5,1375
80009d58:	00e7f463          	bgeu	a5,a4,80009d60 <.L27>

80009d5c <.L26>:
        return status_invalid_argument;
80009d5c:	4789                	li	a5,2
80009d5e:	a831                	j	80009d7a <.L28>

80009d60 <.L27>:
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
80009d60:	47b2                	lw	a5,12(sp)
80009d62:	4b98                	lw	a4,16(a5)
80009d64:	77fd                	lui	a5,0xfffff
80009d66:	8f7d                	and	a4,a4,a5
80009d68:	00a15683          	lhu	a3,10(sp)
80009d6c:	6785                	lui	a5,0x1
80009d6e:	17fd                	addi	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
80009d70:	8ff5                	and	a5,a5,a3
80009d72:	8f5d                	or	a4,a4,a5
80009d74:	47b2                	lw	a5,12(sp)
80009d76:	cb98                	sw	a4,16(a5)
    return stat;
80009d78:	47f2                	lw	a5,28(sp)

80009d7a <.L28>:
}
80009d7a:	853e                	mv	a0,a5
80009d7c:	6105                	addi	sp,sp,32
80009d7e:	8082                	ret

Disassembly of section .text.console_init:

80009d80 <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
80009d80:	7139                	addi	sp,sp,-64
80009d82:	de06                	sw	ra,60(sp)
80009d84:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
80009d86:	4785                	li	a5,1
80009d88:	d63e                	sw	a5,44(sp)

    /* disable buffer in standard library */
    setvbuf(stdin, NULL, _IONBF, 0);
80009d8a:	012007b7          	lui	a5,0x1200
80009d8e:	0587a783          	lw	a5,88(a5) # 1200058 <stdin>
80009d92:	4681                	li	a3,0
80009d94:	4609                	li	a2,2
80009d96:	4581                	li	a1,0
80009d98:	853e                	mv	a0,a5
80009d9a:	2c89                	jal	80009fec <setvbuf>
    setvbuf(stdout, NULL, _IONBF, 0);
80009d9c:	012007b7          	lui	a5,0x1200
80009da0:	0547a783          	lw	a5,84(a5) # 1200054 <stdout>
80009da4:	4681                	li	a3,0
80009da6:	4609                	li	a2,2
80009da8:	4581                	li	a1,0
80009daa:	853e                	mv	a0,a5
80009dac:	2481                	jal	80009fec <setvbuf>

    if (cfg->type == CONSOLE_TYPE_UART) {
80009dae:	47b2                	lw	a5,12(sp)
80009db0:	439c                	lw	a5,0(a5)
80009db2:	eba1                	bnez	a5,80009e02 <.L2>

80009db4 <.LBB2>:
        uart_config_t config = {0};
80009db4:	c802                	sw	zero,16(sp)
80009db6:	ca02                	sw	zero,20(sp)
80009db8:	cc02                	sw	zero,24(sp)
80009dba:	ce02                	sw	zero,28(sp)
80009dbc:	d002                	sw	zero,32(sp)
80009dbe:	d202                	sw	zero,36(sp)
80009dc0:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
80009dc2:	47b2                	lw	a5,12(sp)
80009dc4:	43dc                	lw	a5,4(a5)
80009dc6:	873e                	mv	a4,a5
80009dc8:	081c                	addi	a5,sp,16
80009dca:	85be                	mv	a1,a5
80009dcc:	853a                	mv	a0,a4
80009dce:	904ff0ef          	jal	80008ed2 <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
80009dd2:	47b2                	lw	a5,12(sp)
80009dd4:	479c                	lw	a5,8(a5)
80009dd6:	c83e                	sw	a5,16(sp)
        config.baudrate = cfg->baudrate;
80009dd8:	47b2                	lw	a5,12(sp)
80009dda:	47dc                	lw	a5,12(a5)
80009ddc:	ca3e                	sw	a5,20(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
80009dde:	47b2                	lw	a5,12(sp)
80009de0:	43dc                	lw	a5,4(a5)
80009de2:	873e                	mv	a4,a5
80009de4:	081c                	addi	a5,sp,16
80009de6:	85be                	mv	a1,a5
80009de8:	853a                	mv	a0,a4
80009dea:	898fc0ef          	jal	80005e82 <uart_init>
80009dee:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
80009df0:	57b2                	lw	a5,44(sp)
80009df2:	eb81                	bnez	a5,80009e02 <.L2>
            g_console_uart = (UART_Type *)cfg->base;
80009df4:	47b2                	lw	a5,12(sp)
80009df6:	43dc                	lw	a5,4(a5)
80009df8:	873e                	mv	a4,a5
80009dfa:	012007b7          	lui	a5,0x1200
80009dfe:	02e7a423          	sw	a4,40(a5) # 1200028 <g_console_uart>

80009e02 <.L2>:
        }
    }

    return stat;
80009e02:	57b2                	lw	a5,44(sp)
}
80009e04:	853e                	mv	a0,a5
80009e06:	50f2                	lw	ra,60(sp)
80009e08:	6121                	addi	sp,sp,64
80009e0a:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

80009e0c <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
80009e0c:	7179                	addi	sp,sp,-48
80009e0e:	d606                	sw	ra,44(sp)
80009e10:	c62a                	sw	a0,12(sp)
80009e12:	c42e                	sw	a1,8(sp)
80009e14:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
80009e16:	ce02                	sw	zero,28(sp)
80009e18:	a0b9                	j	80009e66 <.L13>

80009e1a <.L17>:
        if (data[count] == '\n') {
80009e1a:	4722                	lw	a4,8(sp)
80009e1c:	47f2                	lw	a5,28(sp)
80009e1e:	97ba                	add	a5,a5,a4
80009e20:	0007c703          	lbu	a4,0(a5)
80009e24:	47a9                	li	a5,10
80009e26:	00f71d63          	bne	a4,a5,80009e40 <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
80009e2a:	0001                	nop

80009e2c <.L15>:
80009e2c:	012007b7          	lui	a5,0x1200
80009e30:	0287a783          	lw	a5,40(a5) # 1200028 <g_console_uart>
80009e34:	45b5                	li	a1,13
80009e36:	853e                	mv	a0,a5
80009e38:	a16fc0ef          	jal	8000604e <uart_send_byte>
80009e3c:	87aa                	mv	a5,a0
80009e3e:	f7fd                	bnez	a5,80009e2c <.L15>

80009e40 <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
80009e40:	0001                	nop

80009e42 <.L16>:
80009e42:	012007b7          	lui	a5,0x1200
80009e46:	0287a683          	lw	a3,40(a5) # 1200028 <g_console_uart>
80009e4a:	4722                	lw	a4,8(sp)
80009e4c:	47f2                	lw	a5,28(sp)
80009e4e:	97ba                	add	a5,a5,a4
80009e50:	0007c783          	lbu	a5,0(a5)
80009e54:	85be                	mv	a1,a5
80009e56:	8536                	mv	a0,a3
80009e58:	9f6fc0ef          	jal	8000604e <uart_send_byte>
80009e5c:	87aa                	mv	a5,a0
80009e5e:	f3f5                	bnez	a5,80009e42 <.L16>
    for (count = 0; count < size; count++) {
80009e60:	47f2                	lw	a5,28(sp)
80009e62:	0785                	addi	a5,a5,1
80009e64:	ce3e                	sw	a5,28(sp)

80009e66 <.L13>:
80009e66:	4772                	lw	a4,28(sp)
80009e68:	4792                	lw	a5,4(sp)
80009e6a:	faf768e3          	bltu	a4,a5,80009e1a <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
80009e6e:	0001                	nop

80009e70 <.L18>:
80009e70:	012007b7          	lui	a5,0x1200
80009e74:	0287a783          	lw	a5,40(a5) # 1200028 <g_console_uart>
80009e78:	853e                	mv	a0,a5
80009e7a:	b50ff0ef          	jal	800091ca <uart_flush>
80009e7e:	87aa                	mv	a5,a0
80009e80:	fbe5                	bnez	a5,80009e70 <.L18>
    }
    return count;
80009e82:	47f2                	lw	a5,28(sp)

}
80009e84:	853e                	mv	a0,a5
80009e86:	50b2                	lw	ra,44(sp)
80009e88:	6145                	addi	sp,sp,48
80009e8a:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

80009e8c <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
80009e8c:	1141                	addi	sp,sp,-16
80009e8e:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
80009e90:	4781                	li	a5,0
}
80009e92:	853e                	mv	a0,a5
80009e94:	0141                	addi	sp,sp,16
80009e96:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

80009e98 <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
80009e98:	1141                	addi	sp,sp,-16
80009e9a:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
80009e9c:	4785                	li	a5,1
}
80009e9e:	853e                	mv	a0,a5
80009ea0:	0141                	addi	sp,sp,16
80009ea2:	8082                	ret

Disassembly of section .text.libc.__riscv_save_12:

80009ea4 <__riscv_save_12>:
80009ea4:	7139                	addi	sp,sp,-64
80009ea6:	4301                	li	t1,0
80009ea8:	c66e                	sw	s11,12(sp)
80009eaa:	a019                	j	80009eb0 <.L__riscv_save_s10_down>

80009eac <__riscv_save_10>:
80009eac:	7139                	addi	sp,sp,-64
80009eae:	4341                	li	t1,16

80009eb0 <.L__riscv_save_s10_down>:
80009eb0:	c86a                	sw	s10,16(sp)
80009eb2:	ca66                	sw	s9,20(sp)
80009eb4:	cc62                	sw	s8,24(sp)
80009eb6:	ce5e                	sw	s7,28(sp)
80009eb8:	a021                	j	80009ec0 <.L__riscv_save_s6_down>

80009eba <__riscv_save_4>:
80009eba:	7139                	addi	sp,sp,-64
80009ebc:	02000313          	li	t1,32

80009ec0 <.L__riscv_save_s6_down>:
80009ec0:	d05a                	sw	s6,32(sp)
80009ec2:	d256                	sw	s5,36(sp)
80009ec4:	d452                	sw	s4,40(sp)
80009ec6:	d64e                	sw	s3,44(sp)
80009ec8:	d84a                	sw	s2,48(sp)
80009eca:	da26                	sw	s1,52(sp)
80009ecc:	dc22                	sw	s0,56(sp)
80009ece:	de06                	sw	ra,60(sp)
80009ed0:	911a                	add	sp,sp,t1
80009ed2:	8282                	jr	t0

Disassembly of section .text.libc.__riscv_restore_12:

80009ed4 <__riscv_restore_12>:
80009ed4:	4db2                	lw	s11,12(sp)
80009ed6:	0141                	addi	sp,sp,16

80009ed8 <__riscv_restore_11>:
80009ed8:	4d02                	lw	s10,0(sp)

80009eda <__riscv_restore_10>:
80009eda:	4c92                	lw	s9,4(sp)

80009edc <__riscv_restore_9>:
80009edc:	4c22                	lw	s8,8(sp)

80009ede <__riscv_restore_8>:
80009ede:	4bb2                	lw	s7,12(sp)
80009ee0:	0141                	addi	sp,sp,16

80009ee2 <__riscv_restore_7>:
80009ee2:	4b02                	lw	s6,0(sp)

80009ee4 <__riscv_restore_6>:
80009ee4:	4a92                	lw	s5,4(sp)

80009ee6 <__riscv_restore_5>:
80009ee6:	4a22                	lw	s4,8(sp)

80009ee8 <__riscv_restore_4>:
80009ee8:	49b2                	lw	s3,12(sp)
80009eea:	0141                	addi	sp,sp,16

80009eec <__riscv_restore_3>:
80009eec:	4902                	lw	s2,0(sp)

80009eee <__riscv_restore_2>:
80009eee:	4492                	lw	s1,4(sp)

80009ef0 <__riscv_restore_1>:
80009ef0:	4422                	lw	s0,8(sp)

80009ef2 <__riscv_restore_0>:
80009ef2:	40b2                	lw	ra,12(sp)
80009ef4:	0141                	addi	sp,sp,16
80009ef6:	8082                	ret

Disassembly of section .text.libc.itoa:

80009ef8 <itoa>:
80009ef8:	1141                	addi	sp,sp,-16
80009efa:	c606                	sw	ra,12(sp)
80009efc:	c422                	sw	s0,8(sp)
80009efe:	842e                	mv	s0,a1
80009f00:	00055963          	bgez	a0,80009f12 <itoa+0x1a>
80009f04:	45a9                	li	a1,10
80009f06:	00b61663          	bne	a2,a1,80009f12 <itoa+0x1a>
80009f0a:	4629                	li	a2,10
80009f0c:	4685                	li	a3,1
80009f0e:	85a2                	mv	a1,s0
80009f10:	a019                	j	80009f16 <itoa+0x1e>
80009f12:	85a2                	mv	a1,s0
80009f14:	4681                	li	a3,0
80009f16:	84dfc0ef          	jal	80006762 <__SEGGER_RTL_xtoa>
80009f1a:	8522                	mv	a0,s0
80009f1c:	40b2                	lw	ra,12(sp)
80009f1e:	4422                	lw	s0,8(sp)
80009f20:	0141                	addi	sp,sp,16
80009f22:	8082                	ret

Disassembly of section .text.libc.abort:

80009f24 <abort>:
80009f24:	1141                	addi	sp,sp,-16
80009f26:	c606                	sw	ra,12(sp)
80009f28:	4501                	li	a0,0
80009f2a:	2011                	jal	80009f2e <raise>
80009f2c:	bff5                	j	80009f28 <abort+0x4>

Disassembly of section .text.libc.raise:

80009f2e <raise>:
80009f2e:	1141                	addi	sp,sp,-16
80009f30:	c606                	sw	ra,12(sp)
80009f32:	4615                	li	a2,5
80009f34:	55fd                	li	a1,-1
80009f36:	04a66163          	bltu	a2,a0,80009f78 <raise+0x4a>
80009f3a:	00251693          	slli	a3,a0,0x2
80009f3e:	01200637          	lui	a2,0x1200
80009f42:	00060613          	mv	a2,a2
80009f46:	96b2                	add	a3,a3,a2
80009f48:	4290                	lw	a2,0(a3)
80009f4a:	80007737          	lui	a4,0x80007
80009f4e:	81c70713          	addi	a4,a4,-2020 # 8000681c <__SEGGER_RTL_SIGNAL_SIG_IGN>
80009f52:	c298                	sw	a4,0(a3)
80009f54:	c615                	beqz	a2,80009f80 <raise+0x52>
80009f56:	800077b7          	lui	a5,0x80007
80009f5a:	81a78793          	addi	a5,a5,-2022 # 8000681a <__SEGGER_RTL_SIGNAL_SIG_ERR>
80009f5e:	00f60d63          	beq	a2,a5,80009f78 <raise+0x4a>
80009f62:	00e60a63          	beq	a2,a4,80009f76 <raise+0x48>
80009f66:	800035b7          	lui	a1,0x80003
80009f6a:	06658593          	addi	a1,a1,102 # 80003066 <__SEGGER_RTL_SIGNAL_SIG_DFL>
80009f6e:	00b60963          	beq	a2,a1,80009f80 <raise+0x52>
80009f72:	c28c                	sw	a1,0(a3)
80009f74:	9602                	jalr	a2
80009f76:	4581                	li	a1,0
80009f78:	852e                	mv	a0,a1
80009f7a:	40b2                	lw	ra,12(sp)
80009f7c:	0141                	addi	sp,sp,16
80009f7e:	8082                	ret
80009f80:	4505                	li	a0,1
80009f82:	8d8f90ef          	jal	8000305a <exit>

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

80009f86 <__SEGGER_RTL_puts_no_nl>:
80009f86:	1141                	addi	sp,sp,-16
80009f88:	c606                	sw	ra,12(sp)
80009f8a:	c422                	sw	s0,8(sp)
80009f8c:	c226                	sw	s1,4(sp)
80009f8e:	012005b7          	lui	a1,0x1200
80009f92:	0545a403          	lw	s0,84(a1) # 1200054 <stdout>
80009f96:	84aa                	mv	s1,a0
80009f98:	69b000ef          	jal	8000ae32 <strlen>
80009f9c:	862a                	mv	a2,a0
80009f9e:	8522                	mv	a0,s0
80009fa0:	85a6                	mv	a1,s1
80009fa2:	40b2                	lw	ra,12(sp)
80009fa4:	4422                	lw	s0,8(sp)
80009fa6:	4492                	lw	s1,4(sp)
80009fa8:	0141                	addi	sp,sp,16
80009faa:	b58d                	j	80009e0c <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.fwrite:

80009fac <fwrite>:
80009fac:	1101                	addi	sp,sp,-32
80009fae:	ce06                	sw	ra,28(sp)
80009fb0:	cc22                	sw	s0,24(sp)
80009fb2:	ca26                	sw	s1,20(sp)
80009fb4:	c84a                	sw	s2,16(sp)
80009fb6:	c64e                	sw	s3,12(sp)
80009fb8:	84b6                	mv	s1,a3
80009fba:	89b2                	mv	s3,a2
80009fbc:	842e                	mv	s0,a1
80009fbe:	892a                	mv	s2,a0
80009fc0:	8536                	mv	a0,a3
80009fc2:	35e9                	jal	80009e8c <__SEGGER_RTL_X_file_stat>
80009fc4:	00054663          	bltz	a0,80009fd0 <fwrite+0x24>
80009fc8:	02898633          	mul	a2,s3,s0
80009fcc:	00867463          	bgeu	a2,s0,80009fd4 <fwrite+0x28>
80009fd0:	4501                	li	a0,0
80009fd2:	a031                	j	80009fde <fwrite+0x32>
80009fd4:	8526                	mv	a0,s1
80009fd6:	85ca                	mv	a1,s2
80009fd8:	3d15                	jal	80009e0c <__SEGGER_RTL_X_file_write>
80009fda:	02855533          	divu	a0,a0,s0
80009fde:	40f2                	lw	ra,28(sp)
80009fe0:	4462                	lw	s0,24(sp)
80009fe2:	44d2                	lw	s1,20(sp)
80009fe4:	4942                	lw	s2,16(sp)
80009fe6:	49b2                	lw	s3,12(sp)
80009fe8:	6105                	addi	sp,sp,32
80009fea:	8082                	ret

Disassembly of section .text.libc.setvbuf:

80009fec <setvbuf>:
80009fec:	4501                	li	a0,0
80009fee:	8082                	ret

Disassembly of section .text.libc.__mulsf3:

80009ff0 <__mulsf3>:
80009ff0:	80000737          	lui	a4,0x80000
80009ff4:	0ff00293          	li	t0,255
80009ff8:	00b547b3          	xor	a5,a0,a1
80009ffc:	8ff9                	and	a5,a5,a4
80009ffe:	00151613          	slli	a2,a0,0x1
8000a002:	8261                	srli	a2,a2,0x18
8000a004:	00159693          	slli	a3,a1,0x1
8000a008:	82e1                	srli	a3,a3,0x18
8000a00a:	ce29                	beqz	a2,8000a064 <.L__mulsf3_lhs_zero_or_subnormal>
8000a00c:	c6bd                	beqz	a3,8000a07a <.L__mulsf3_rhs_zero_or_subnormal>
8000a00e:	04560f63          	beq	a2,t0,8000a06c <.L__mulsf3_lhs_inf_or_nan>
8000a012:	06568963          	beq	a3,t0,8000a084 <.L__mulsf3_rhs_inf_or_nan>
8000a016:	9636                	add	a2,a2,a3
8000a018:	0522                	slli	a0,a0,0x8
8000a01a:	8d59                	or	a0,a0,a4
8000a01c:	05a2                	slli	a1,a1,0x8
8000a01e:	8dd9                	or	a1,a1,a4
8000a020:	02b506b3          	mul	a3,a0,a1
8000a024:	02b53533          	mulhu	a0,a0,a1
8000a028:	00d036b3          	snez	a3,a3
8000a02c:	8d55                	or	a0,a0,a3
8000a02e:	00054463          	bltz	a0,8000a036 <.L__mulsf3_normalized>
8000a032:	0506                	slli	a0,a0,0x1
8000a034:	167d                	addi	a2,a2,-1 # 11fffff <__DLM_segment_end__+0xfdffff>

8000a036 <.L__mulsf3_normalized>:
8000a036:	f8160613          	addi	a2,a2,-127
8000a03a:	04064863          	bltz	a2,8000a08a <.L__mulsf3_zero_or_underflow>
8000a03e:	12fd                	addi	t0,t0,-1 # ffffffff <__AHB_SRAM_segment_end__+0xfdf7fff>
8000a040:	00565f63          	bge	a2,t0,8000a05e <.L__mulsf3_inf>
8000a044:	01851693          	slli	a3,a0,0x18
8000a048:	8121                	srli	a0,a0,0x8
8000a04a:	065e                	slli	a2,a2,0x17
8000a04c:	9532                	add	a0,a0,a2
8000a04e:	0006d663          	bgez	a3,8000a05a <.L__mulsf3_apply_sign>
8000a052:	0505                	addi	a0,a0,1 # f40c0001 <__AHB_SRAM_segment_end__+0x3eb8001>
8000a054:	0686                	slli	a3,a3,0x1
8000a056:	e291                	bnez	a3,8000a05a <.L__mulsf3_apply_sign>
8000a058:	9979                	andi	a0,a0,-2

8000a05a <.L__mulsf3_apply_sign>:
8000a05a:	8d5d                	or	a0,a0,a5
8000a05c:	8082                	ret

8000a05e <.L__mulsf3_inf>:
8000a05e:	7f800537          	lui	a0,0x7f800
8000a062:	bfe5                	j	8000a05a <.L__mulsf3_apply_sign>

8000a064 <.L__mulsf3_lhs_zero_or_subnormal>:
8000a064:	00568d63          	beq	a3,t0,8000a07e <.L__mulsf3_nan>

8000a068 <.L__mulsf3_signed_zero>:
8000a068:	853e                	mv	a0,a5
8000a06a:	8082                	ret

8000a06c <.L__mulsf3_lhs_inf_or_nan>:
8000a06c:	0526                	slli	a0,a0,0x9
8000a06e:	e901                	bnez	a0,8000a07e <.L__mulsf3_nan>
8000a070:	fe5697e3          	bne	a3,t0,8000a05e <.L__mulsf3_inf>
8000a074:	05a6                	slli	a1,a1,0x9
8000a076:	e581                	bnez	a1,8000a07e <.L__mulsf3_nan>
8000a078:	b7dd                	j	8000a05e <.L__mulsf3_inf>

8000a07a <.L__mulsf3_rhs_zero_or_subnormal>:
8000a07a:	fe5617e3          	bne	a2,t0,8000a068 <.L__mulsf3_signed_zero>

8000a07e <.L__mulsf3_nan>:
8000a07e:	7fc00537          	lui	a0,0x7fc00
8000a082:	8082                	ret

8000a084 <.L__mulsf3_rhs_inf_or_nan>:
8000a084:	05a6                	slli	a1,a1,0x9
8000a086:	fde5                	bnez	a1,8000a07e <.L__mulsf3_nan>
8000a088:	bfd9                	j	8000a05e <.L__mulsf3_inf>

8000a08a <.L__mulsf3_zero_or_underflow>:
8000a08a:	0605                	addi	a2,a2,1
8000a08c:	fe71                	bnez	a2,8000a068 <.L__mulsf3_signed_zero>
8000a08e:	8521                	srai	a0,a0,0x8
8000a090:	00150293          	addi	t0,a0,1 # 7fc00001 <__NONCACHEABLE_RAM_segment_end__+0x7e9c0001>
8000a094:	0509                	addi	a0,a0,2
8000a096:	fc0299e3          	bnez	t0,8000a068 <.L__mulsf3_signed_zero>
8000a09a:	00800537          	lui	a0,0x800
8000a09e:	bf75                	j	8000a05a <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__divsf3:

8000a0a0 <__divsf3>:
8000a0a0:	0ff00293          	li	t0,255
8000a0a4:	00151713          	slli	a4,a0,0x1
8000a0a8:	8361                	srli	a4,a4,0x18
8000a0aa:	00159793          	slli	a5,a1,0x1
8000a0ae:	83e1                	srli	a5,a5,0x18
8000a0b0:	00b54333          	xor	t1,a0,a1
8000a0b4:	01f35313          	srli	t1,t1,0x1f
8000a0b8:	037e                	slli	t1,t1,0x1f
8000a0ba:	cf4d                	beqz	a4,8000a174 <.L__divsf3_lhs_zero_or_subnormal>
8000a0bc:	cbe9                	beqz	a5,8000a18e <.L__divsf3_rhs_zero_or_subnormal>
8000a0be:	0c570363          	beq	a4,t0,8000a184 <.L__divsf3_lhs_inf_or_nan>
8000a0c2:	0c578b63          	beq	a5,t0,8000a198 <.L__divsf3_rhs_inf_or_nan>
8000a0c6:	8f1d                	sub	a4,a4,a5

8000a0c8 <.Lpcrel_hi0>:
8000a0c8:	b5c18293          	addi	t0,gp,-1188 # 80003c90 <__SEGGER_RTL_fdiv_reciprocal_table>
8000a0cc:	00f5d693          	srli	a3,a1,0xf
8000a0d0:	0fc6f693          	andi	a3,a3,252
8000a0d4:	9696                	add	a3,a3,t0
8000a0d6:	429c                	lw	a5,0(a3)
8000a0d8:	4187d613          	srai	a2,a5,0x18
8000a0dc:	00f59693          	slli	a3,a1,0xf
8000a0e0:	82e1                	srli	a3,a3,0x18
8000a0e2:	0016f293          	andi	t0,a3,1
8000a0e6:	8285                	srli	a3,a3,0x1
8000a0e8:	fc068693          	addi	a3,a3,-64
8000a0ec:	9696                	add	a3,a3,t0
8000a0ee:	02d60633          	mul	a2,a2,a3
8000a0f2:	07a2                	slli	a5,a5,0x8
8000a0f4:	83a1                	srli	a5,a5,0x8
8000a0f6:	963e                	add	a2,a2,a5
8000a0f8:	05a2                	slli	a1,a1,0x8
8000a0fa:	81a1                	srli	a1,a1,0x8
8000a0fc:	008007b7          	lui	a5,0x800
8000a100:	8ddd                	or	a1,a1,a5
8000a102:	02c586b3          	mul	a3,a1,a2
8000a106:	0522                	slli	a0,a0,0x8
8000a108:	8121                	srli	a0,a0,0x8
8000a10a:	8d5d                	or	a0,a0,a5
8000a10c:	02c697b3          	mulh	a5,a3,a2
8000a110:	00b532b3          	sltu	t0,a0,a1
8000a114:	00551533          	sll	a0,a0,t0
8000a118:	40570733          	sub	a4,a4,t0
8000a11c:	01465693          	srli	a3,a2,0x14
8000a120:	8a85                	andi	a3,a3,1
8000a122:	0016c693          	xori	a3,a3,1
8000a126:	062e                	slli	a2,a2,0xb
8000a128:	8e1d                	sub	a2,a2,a5
8000a12a:	8e15                	sub	a2,a2,a3
8000a12c:	050a                	slli	a0,a0,0x2
8000a12e:	02a617b3          	mulh	a5,a2,a0
8000a132:	07e70613          	addi	a2,a4,126 # 8000007e <__NONCACHEABLE_RAM_segment_end__+0x7edc007e>
8000a136:	055a                	slli	a0,a0,0x16
8000a138:	8d0d                	sub	a0,a0,a1
8000a13a:	02b786b3          	mul	a3,a5,a1
8000a13e:	0fe00293          	li	t0,254
8000a142:	00567f63          	bgeu	a2,t0,8000a160 <.L__divsf3_underflow_or_overflow>
8000a146:	40a68533          	sub	a0,a3,a0
8000a14a:	000522b3          	sltz	t0,a0
8000a14e:	9796                	add	a5,a5,t0
8000a150:	0017f513          	andi	a0,a5,1
8000a154:	8385                	srli	a5,a5,0x1
8000a156:	953e                	add	a0,a0,a5
8000a158:	065e                	slli	a2,a2,0x17
8000a15a:	9532                	add	a0,a0,a2
8000a15c:	951a                	add	a0,a0,t1
8000a15e:	8082                	ret

8000a160 <.L__divsf3_underflow_or_overflow>:
8000a160:	851a                	mv	a0,t1
8000a162:	00564563          	blt	a2,t0,8000a16c <.L__divsf3_done>
8000a166:	7f800337          	lui	t1,0x7f800

8000a16a <.L__divsf3_apply_sign>:
8000a16a:	951a                	add	a0,a0,t1

8000a16c <.L__divsf3_done>:
8000a16c:	8082                	ret

8000a16e <.L__divsf3_inf>:
8000a16e:	7f800537          	lui	a0,0x7f800
8000a172:	bfe5                	j	8000a16a <.L__divsf3_apply_sign>

8000a174 <.L__divsf3_lhs_zero_or_subnormal>:
8000a174:	c789                	beqz	a5,8000a17e <.L__divsf3_nan>
8000a176:	02579363          	bne	a5,t0,8000a19c <.L__divsf3_signed_zero>
8000a17a:	05a6                	slli	a1,a1,0x9
8000a17c:	c185                	beqz	a1,8000a19c <.L__divsf3_signed_zero>

8000a17e <.L__divsf3_nan>:
8000a17e:	7fc00537          	lui	a0,0x7fc00
8000a182:	8082                	ret

8000a184 <.L__divsf3_lhs_inf_or_nan>:
8000a184:	0526                	slli	a0,a0,0x9
8000a186:	fd65                	bnez	a0,8000a17e <.L__divsf3_nan>
8000a188:	fe5793e3          	bne	a5,t0,8000a16e <.L__divsf3_inf>
8000a18c:	bfcd                	j	8000a17e <.L__divsf3_nan>

8000a18e <.L__divsf3_rhs_zero_or_subnormal>:
8000a18e:	fe5710e3          	bne	a4,t0,8000a16e <.L__divsf3_inf>
8000a192:	0526                	slli	a0,a0,0x9
8000a194:	f56d                	bnez	a0,8000a17e <.L__divsf3_nan>
8000a196:	bfe1                	j	8000a16e <.L__divsf3_inf>

8000a198 <.L__divsf3_rhs_inf_or_nan>:
8000a198:	05a6                	slli	a1,a1,0x9
8000a19a:	f1f5                	bnez	a1,8000a17e <.L__divsf3_nan>

8000a19c <.L__divsf3_signed_zero>:
8000a19c:	851a                	mv	a0,t1
8000a19e:	8082                	ret

Disassembly of section .text.libc.__eqsf2:

8000a1a0 <__eqsf2>:
8000a1a0:	ff000637          	lui	a2,0xff000
8000a1a4:	00151693          	slli	a3,a0,0x1
8000a1a8:	02d66063          	bltu	a2,a3,8000a1c8 <.L__eqsf2_one>
8000a1ac:	00159693          	slli	a3,a1,0x1
8000a1b0:	00d66c63          	bltu	a2,a3,8000a1c8 <.L__eqsf2_one>
8000a1b4:	00b56633          	or	a2,a0,a1
8000a1b8:	0606                	slli	a2,a2,0x1
8000a1ba:	c609                	beqz	a2,8000a1c4 <.L__eqsf2_zero>
8000a1bc:	8d0d                	sub	a0,a0,a1
8000a1be:	00a03533          	snez	a0,a0
8000a1c2:	8082                	ret

8000a1c4 <.L__eqsf2_zero>:
8000a1c4:	4501                	li	a0,0
8000a1c6:	8082                	ret

8000a1c8 <.L__eqsf2_one>:
8000a1c8:	4505                	li	a0,1
8000a1ca:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

8000a1cc <__fixunssfdi>:
8000a1cc:	04054a63          	bltz	a0,8000a220 <.L__fixunssfdi_zero_result>
8000a1d0:	00151613          	slli	a2,a0,0x1
8000a1d4:	8261                	srli	a2,a2,0x18
8000a1d6:	f8160613          	addi	a2,a2,-127 # feffff81 <__AHB_SRAM_segment_end__+0xedf7f81>
8000a1da:	04064363          	bltz	a2,8000a220 <.L__fixunssfdi_zero_result>
8000a1de:	800006b7          	lui	a3,0x80000
8000a1e2:	02000293          	li	t0,32
8000a1e6:	00565b63          	bge	a2,t0,8000a1fc <.L__fixunssfdi_long_shift>
8000a1ea:	40c00633          	neg	a2,a2
8000a1ee:	067d                	addi	a2,a2,31
8000a1f0:	0522                	slli	a0,a0,0x8
8000a1f2:	8d55                	or	a0,a0,a3
8000a1f4:	00c55533          	srl	a0,a0,a2
8000a1f8:	4581                	li	a1,0
8000a1fa:	8082                	ret

8000a1fc <.L__fixunssfdi_long_shift>:
8000a1fc:	40c00633          	neg	a2,a2
8000a200:	03f60613          	addi	a2,a2,63
8000a204:	02064163          	bltz	a2,8000a226 <.L__fixunssfdi_overflow_result>
8000a208:	00851593          	slli	a1,a0,0x8
8000a20c:	8dd5                	or	a1,a1,a3
8000a20e:	4501                	li	a0,0
8000a210:	c619                	beqz	a2,8000a21e <.L__fixunssfdi_shift_32>
8000a212:	40c006b3          	neg	a3,a2
8000a216:	00d59533          	sll	a0,a1,a3
8000a21a:	00c5d5b3          	srl	a1,a1,a2

8000a21e <.L__fixunssfdi_shift_32>:
8000a21e:	8082                	ret

8000a220 <.L__fixunssfdi_zero_result>:
8000a220:	4501                	li	a0,0
8000a222:	4581                	li	a1,0
8000a224:	8082                	ret

8000a226 <.L__fixunssfdi_overflow_result>:
8000a226:	557d                	li	a0,-1
8000a228:	55fd                	li	a1,-1
8000a22a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

8000a22c <__SEGGER_RTL_ldouble_to_double>:
8000a22c:	00169793          	slli	a5,a3,0x1
8000a230:	453d                	li	a0,15
8000a232:	83c5                	srli	a5,a5,0x11
8000a234:	052a                	slli	a0,a0,0xa
8000a236:	80000837          	lui	a6,0x80000
8000a23a:	00f56663          	bltu	a0,a5,8000a246 <__SEGGER_RTL_ldouble_to_double+0x1a>
8000a23e:	4501                	li	a0,0
8000a240:	0106f5b3          	and	a1,a3,a6
8000a244:	8082                	ret
8000a246:	5545                	li	a0,-15
8000a248:	6711                	lui	a4,0x4
8000a24a:	052a                	slli	a0,a0,0xa
8000a24c:	953e                	add	a0,a0,a5
8000a24e:	3ff70713          	addi	a4,a4,1023 # 43ff <__HEAPSIZE__+0x3ff>
8000a252:	83a9                	srli	a5,a5,0xa
8000a254:	00e50963          	beq	a0,a4,8000a266 <__SEGGER_RTL_ldouble_to_double+0x3a>
8000a258:	0117b713          	sltiu	a4,a5,17
8000a25c:	40e00733          	neg	a4,a4
8000a260:	8ef9                	and	a3,a3,a4
8000a262:	8e79                	and	a2,a2,a4
8000a264:	8df9                	and	a1,a1,a4
8000a266:	4741                	li	a4,16
8000a268:	00f77463          	bgeu	a4,a5,8000a270 <__SEGGER_RTL_ldouble_to_double+0x44>
8000a26c:	7ff00513          	li	a0,2047
8000a270:	0106f733          	and	a4,a3,a6
8000a274:	0552                	slli	a0,a0,0x14
8000a276:	8d59                	or	a0,a0,a4
8000a278:	01c65713          	srli	a4,a2,0x1c
8000a27c:	0692                	slli	a3,a3,0x4
8000a27e:	0612                	slli	a2,a2,0x4
8000a280:	01c5d793          	srli	a5,a1,0x1c
8000a284:	8ed9                	or	a3,a3,a4
8000a286:	06b2                	slli	a3,a3,0xc
8000a288:	00c6d593          	srli	a1,a3,0xc
8000a28c:	8dc9                	or	a1,a1,a0
8000a28e:	00f66533          	or	a0,a2,a5
8000a292:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

8000a294 <__trunctfsf2>:
8000a294:	1141                	addi	sp,sp,-16
8000a296:	c606                	sw	ra,12(sp)
8000a298:	4118                	lw	a4,0(a0)
8000a29a:	414c                	lw	a1,4(a0)
8000a29c:	4510                	lw	a2,8(a0)
8000a29e:	4554                	lw	a3,12(a0)
8000a2a0:	853a                	mv	a0,a4
8000a2a2:	3769                	jal	8000a22c <__SEGGER_RTL_ldouble_to_double>
8000a2a4:	9f3fc0ef          	jal	80006c96 <__truncdfsf2>
8000a2a8:	40b2                	lw	ra,12(sp)
8000a2aa:	0141                	addi	sp,sp,16
8000a2ac:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

8000a2ae <__SEGGER_RTL_float32_isnan>:
8000a2ae:	0506                	slli	a0,a0,0x1
8000a2b0:	ff0005b7          	lui	a1,0xff000
8000a2b4:	00a5b533          	sltu	a0,a1,a0
8000a2b8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

8000a2ba <__SEGGER_RTL_float32_isinf>:
8000a2ba:	0506                	slli	a0,a0,0x1
8000a2bc:	8105                	srli	a0,a0,0x1
8000a2be:	7f8005b7          	lui	a1,0x7f800
8000a2c2:	8d2d                	xor	a0,a0,a1
8000a2c4:	00153513          	seqz	a0,a0
8000a2c8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

8000a2ca <__SEGGER_RTL_float32_isnormal>:
8000a2ca:	00151593          	slli	a1,a0,0x1
8000a2ce:	7f800637          	lui	a2,0x7f800
8000a2d2:	81e1                	srli	a1,a1,0x18
8000a2d4:	8d71                	and	a0,a0,a2
8000a2d6:	0ff5b593          	sltiu	a1,a1,255
8000a2da:	00a03533          	snez	a0,a0
8000a2de:	8d6d                	and	a0,a0,a1
8000a2e0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

8000a2e2 <__SEGGER_RTL_float32_signbit>:
8000a2e2:	817d                	srli	a0,a0,0x1f
8000a2e4:	8082                	ret

Disassembly of section .text.libc.ldexpf:

8000a2e6 <ldexpf>:
8000a2e6:	00151613          	slli	a2,a0,0x1
8000a2ea:	8261                	srli	a2,a2,0x18
8000a2ec:	f0160693          	addi	a3,a2,-255 # 7f7fff01 <__NONCACHEABLE_RAM_segment_end__+0x7e5bff01>
8000a2f0:	f0200713          	li	a4,-254
8000a2f4:	02e6ea63          	bltu	a3,a4,8000a328 <ldexpf+0x42>
8000a2f8:	95b2                	add	a1,a1,a2
8000a2fa:	fff58613          	addi	a2,a1,-1 # 7f7fffff <__NONCACHEABLE_RAM_segment_end__+0x7e5bffff>
8000a2fe:	0fd00693          	li	a3,253
8000a302:	00c6e963          	bltu	a3,a2,8000a314 <ldexpf+0x2e>
8000a306:	80800637          	lui	a2,0x80800
8000a30a:	167d                	addi	a2,a2,-1 # 807fffff <__FLASH_segment_end__+0x6fffff>
8000a30c:	8d71                	and	a0,a0,a2
8000a30e:	05de                	slli	a1,a1,0x17
8000a310:	8d4d                	or	a0,a0,a1
8000a312:	8082                	ret
8000a314:	0015a593          	slti	a1,a1,1
8000a318:	80000637          	lui	a2,0x80000
8000a31c:	8d71                	and	a0,a0,a2
8000a31e:	15fd                	addi	a1,a1,-1
8000a320:	7f800637          	lui	a2,0x7f800
8000a324:	8df1                	and	a1,a1,a2
8000a326:	8d4d                	or	a0,a0,a1
8000a328:	8082                	ret

Disassembly of section .text.libc.fmodf:

8000a32a <fmodf>:
8000a32a:	b91ff2ef          	jal	t0,80009eba <__riscv_save_4>
8000a32e:	84aa                	mv	s1,a0
8000a330:	01755993          	srli	s3,a0,0x17
8000a334:	fff98513          	addi	a0,s3,-1
8000a338:	0fd00613          	li	a2,253
8000a33c:	0ea66363          	bltu	a2,a0,8000a422 <fmodf+0xf8>
8000a340:	0175d513          	srli	a0,a1,0x17
8000a344:	f0150513          	addi	a0,a0,-255 # 7fbfff01 <__NONCACHEABLE_RAM_segment_end__+0x7e9bff01>
8000a348:	f0200613          	li	a2,-254
8000a34c:	0cc56b63          	bltu	a0,a2,8000a422 <fmodf+0xf8>
8000a350:	00149413          	slli	s0,s1,0x1
8000a354:	8005                	srli	s0,s0,0x1
8000a356:	80000537          	lui	a0,0x80000
8000a35a:	00a4f933          	and	s2,s1,a0
8000a35e:	1085f063          	bgeu	a1,s0,8000a45e <fmodf+0x134>
8000a362:	00800637          	lui	a2,0x800
8000a366:	0ff9f513          	zext.b	a0,s3
8000a36a:	fff60693          	addi	a3,a2,-1 # 7fffff <__DLM_segment_end__+0x5dffff>
8000a36e:	c509                	beqz	a0,8000a378 <fmodf+0x4e>
8000a370:	00d4f433          	and	s0,s1,a3
8000a374:	8c51                	or	s0,s0,a2
8000a376:	a831                	j	8000a392 <fmodf+0x68>
8000a378:	01745513          	srli	a0,s0,0x17
8000a37c:	e911                	bnez	a0,8000a390 <fmodf+0x66>
8000a37e:	8622                	mv	a2,s0
8000a380:	00161413          	slli	s0,a2,0x1
8000a384:	01665713          	srli	a4,a2,0x16
8000a388:	157d                	addi	a0,a0,-1 # 7fffffff <__NONCACHEABLE_RAM_segment_end__+0x7edbffff>
8000a38a:	8622                	mv	a2,s0
8000a38c:	db75                	beqz	a4,8000a380 <fmodf+0x56>
8000a38e:	a011                	j	8000a392 <fmodf+0x68>
8000a390:	4501                	li	a0,0
8000a392:	00159613          	slli	a2,a1,0x1
8000a396:	8261                	srli	a2,a2,0x18
8000a398:	ca01                	beqz	a2,8000a3a8 <fmodf+0x7e>
8000a39a:	8df5                	and	a1,a1,a3
8000a39c:	008006b7          	lui	a3,0x800
8000a3a0:	8dd5                	or	a1,a1,a3
8000a3a2:	02a64063          	blt	a2,a0,8000a3c2 <fmodf+0x98>
8000a3a6:	a081                	j	8000a3e6 <fmodf+0xbc>
8000a3a8:	0175d613          	srli	a2,a1,0x17
8000a3ac:	ea15                	bnez	a2,8000a3e0 <fmodf+0xb6>
8000a3ae:	86ae                	mv	a3,a1
8000a3b0:	00169593          	slli	a1,a3,0x1
8000a3b4:	0166d713          	srli	a4,a3,0x16
8000a3b8:	167d                	addi	a2,a2,-1
8000a3ba:	86ae                	mv	a3,a1
8000a3bc:	db75                	beqz	a4,8000a3b0 <fmodf+0x86>
8000a3be:	02a65463          	bge	a2,a0,8000a3e6 <fmodf+0xbc>
8000a3c2:	40b406b3          	sub	a3,s0,a1
8000a3c6:	0006c563          	bltz	a3,8000a3d0 <fmodf+0xa6>
8000a3ca:	04b40a63          	beq	s0,a1,8000a41e <fmodf+0xf4>
8000a3ce:	a011                	j	8000a3d2 <fmodf+0xa8>
8000a3d0:	86a2                	mv	a3,s0
8000a3d2:	157d                	addi	a0,a0,-1
8000a3d4:	00169413          	slli	s0,a3,0x1
8000a3d8:	fea645e3          	blt	a2,a0,8000a3c2 <fmodf+0x98>
8000a3dc:	8532                	mv	a0,a2
8000a3de:	a021                	j	8000a3e6 <fmodf+0xbc>
8000a3e0:	4601                	li	a2,0
8000a3e2:	fea040e3          	bgtz	a0,8000a3c2 <fmodf+0x98>
8000a3e6:	40b40633          	sub	a2,s0,a1
8000a3ea:	00064563          	bltz	a2,8000a3f4 <fmodf+0xca>
8000a3ee:	00b41463          	bne	s0,a1,8000a3f6 <fmodf+0xcc>
8000a3f2:	a035                	j	8000a41e <fmodf+0xf4>
8000a3f4:	8622                	mv	a2,s0
8000a3f6:	01765593          	srli	a1,a2,0x17
8000a3fa:	e989                	bnez	a1,8000a40c <fmodf+0xe2>
8000a3fc:	00161593          	slli	a1,a2,0x1
8000a400:	01665693          	srli	a3,a2,0x16
8000a404:	157d                	addi	a0,a0,-1
8000a406:	862e                	mv	a2,a1
8000a408:	daf5                	beqz	a3,8000a3fc <fmodf+0xd2>
8000a40a:	a011                	j	8000a40e <fmodf+0xe4>
8000a40c:	85b2                	mv	a1,a2
8000a40e:	04a05c63          	blez	a0,8000a466 <fmodf+0x13c>
8000a412:	fff50613          	addi	a2,a0,-1
8000a416:	065e                	slli	a2,a2,0x17
8000a418:	964a                	add	a2,a2,s2
8000a41a:	00c58933          	add	s2,a1,a2
8000a41e:	854a                	mv	a0,s2
8000a420:	b4d9                	j	80009ee6 <__riscv_restore_5>
8000a422:	00149413          	slli	s0,s1,0x1
8000a426:	ff000537          	lui	a0,0xff000
8000a42a:	02856c63          	bltu	a0,s0,8000a462 <fmodf+0x138>
8000a42e:	00159a13          	slli	s4,a1,0x1
8000a432:	05456063          	bltu	a0,s4,8000a472 <fmodf+0x148>
8000a436:	8005                	srli	s0,s0,0x1
8000a438:	7f800537          	lui	a0,0x7f800
8000a43c:	7fc00937          	lui	s2,0x7fc00
8000a440:	fca40fe3          	beq	s0,a0,8000a41e <fmodf+0xf4>
8000a444:	e409                	bnez	s0,8000a44e <fmodf+0x124>
8000a446:	852e                	mv	a0,a1
8000a448:	4581                	li	a1,0
8000a44a:	3b99                	jal	8000a1a0 <__eqsf2>
8000a44c:	e919                	bnez	a0,8000a462 <fmodf+0x138>
8000a44e:	001a5593          	srli	a1,s4,0x1
8000a452:	d5f1                	beqz	a1,8000a41e <fmodf+0xf4>
8000a454:	7f800537          	lui	a0,0x7f800
8000a458:	eea59fe3          	bne	a1,a0,8000a356 <fmodf+0x2c>
8000a45c:	a019                	j	8000a462 <fmodf+0x138>
8000a45e:	fc8580e3          	beq	a1,s0,8000a41e <fmodf+0xf4>
8000a462:	8926                	mv	s2,s1
8000a464:	bf6d                	j	8000a41e <fmodf+0xf4>
8000a466:	4601                	li	a2,0
8000a468:	4685                	li	a3,1
8000a46a:	8e89                	sub	a3,a3,a0
8000a46c:	00d5d5b3          	srl	a1,a1,a3
8000a470:	b75d                	j	8000a416 <fmodf+0xec>
8000a472:	892e                	mv	s2,a1
8000a474:	b76d                	j	8000a41e <fmodf+0xf4>

Disassembly of section .text.libc.floorf:

8000a476 <floorf>:
8000a476:	00151593          	slli	a1,a0,0x1
8000a47a:	81e1                	srli	a1,a1,0x18
8000a47c:	fff58613          	addi	a2,a1,-1
8000a480:	0fe00693          	li	a3,254
8000a484:	04d67963          	bgeu	a2,a3,8000a4d6 <floorf+0x60>
8000a488:	07e00613          	li	a2,126
8000a48c:	00b66763          	bltu	a2,a1,8000a49a <floorf+0x24>
8000a490:	857d                	srai	a0,a0,0x1f
8000a492:	bf8005b7          	lui	a1,0xbf800
8000a496:	8d6d                	and	a0,a0,a1
8000a498:	8082                	ret
8000a49a:	09500613          	li	a2,149
8000a49e:	02b66b63          	bltu	a2,a1,8000a4d4 <floorf+0x5e>
8000a4a2:	f8158593          	addi	a1,a1,-127 # bf7fff81 <__FLASH_segment_end__+0x3f6fff81>
8000a4a6:	ff800637          	lui	a2,0xff800
8000a4aa:	00052693          	slti	a3,a0,0
8000a4ae:	40b65633          	sra	a2,a2,a1
8000a4b2:	8e69                	and	a2,a2,a0
8000a4b4:	00b51533          	sll	a0,a0,a1
8000a4b8:	0016c693          	xori	a3,a3,1
8000a4bc:	0526                	slli	a0,a0,0x9
8000a4be:	8125                	srli	a0,a0,0x9
8000a4c0:	00153513          	seqz	a0,a0
8000a4c4:	8d55                	or	a0,a0,a3
8000a4c6:	008006b7          	lui	a3,0x800
8000a4ca:	00b6d5b3          	srl	a1,a3,a1
8000a4ce:	157d                	addi	a0,a0,-1 # 7f7fffff <__NONCACHEABLE_RAM_segment_end__+0x7e5bffff>
8000a4d0:	8d6d                	and	a0,a0,a1
8000a4d2:	9532                	add	a0,a0,a2
8000a4d4:	8082                	ret
8000a4d6:	fdfd                	bnez	a1,8000a4d4 <floorf+0x5e>
8000a4d8:	800005b7          	lui	a1,0x80000
8000a4dc:	bf6d                	j	8000a496 <floorf+0x20>

Disassembly of section .text.libc.__udivdi3:

8000a4de <__udivdi3>:
8000a4de:	872e                	mv	a4,a1
8000a4e0:	e2b1                	bnez	a3,8000a524 <__udivdi3+0x46>
8000a4e2:	2a070863          	beqz	a4,8000a792 <__udivdi3+0x2b4>
8000a4e6:	01865793          	srli	a5,a2,0x18
8000a4ea:	8fd5                	or	a5,a5,a3
8000a4ec:	ef85                	bnez	a5,8000a524 <__udivdi3+0x46>
8000a4ee:	00563813          	sltiu	a6,a2,5
8000a4f2:	0016b793          	seqz	a5,a3
8000a4f6:	0107f7b3          	and	a5,a5,a6
8000a4fa:	3c078363          	beqz	a5,8000a8c0 <__udivdi3+0x3e2>
8000a4fe:	4689                	li	a3,2
8000a500:	3ec6ce63          	blt	a3,a2,8000a8fc <__udivdi3+0x41e>
8000a504:	4785                	li	a5,1
8000a506:	86aa                	mv	a3,a0
8000a508:	28f60f63          	beq	a2,a5,8000a7a6 <__udivdi3+0x2c8>
8000a50c:	4681                	li	a3,0
8000a50e:	4789                	li	a5,2
8000a510:	4701                	li	a4,0
8000a512:	28f61a63          	bne	a2,a5,8000a7a6 <__udivdi3+0x2c8>
8000a516:	8105                	srli	a0,a0,0x1
8000a518:	01f59693          	slli	a3,a1,0x1f
8000a51c:	8ec9                	or	a3,a3,a0
8000a51e:	0015d713          	srli	a4,a1,0x1
8000a522:	a451                	j	8000a7a6 <__udivdi3+0x2c8>
8000a524:	14068e63          	beqz	a3,8000a680 <__udivdi3+0x1a2>
8000a528:	0106d813          	srli	a6,a3,0x10
8000a52c:	00155293          	srli	t0,a0,0x1
8000a530:	01f59713          	slli	a4,a1,0x1f
8000a534:	0015d893          	srli	a7,a1,0x1
8000a538:	00165313          	srli	t1,a2,0x1
8000a53c:	8000b3b7          	lui	t2,0x8000b
8000a540:	9ca38393          	addi	t2,t2,-1590 # 8000a9ca <__SEGGER_RTL_Moeller_inverse_lut>
8000a544:	00183793          	seqz	a5,a6
8000a548:	00e2e2b3          	or	t0,t0,a4
8000a54c:	00479813          	slli	a6,a5,0x4
8000a550:	010697b3          	sll	a5,a3,a6
8000a554:	0187d713          	srli	a4,a5,0x18
8000a558:	00173713          	seqz	a4,a4
8000a55c:	070e                	slli	a4,a4,0x3
8000a55e:	00e79e33          	sll	t3,a5,a4
8000a562:	00e86833          	or	a6,a6,a4
8000a566:	01ce5793          	srli	a5,t3,0x1c
8000a56a:	0017b793          	seqz	a5,a5
8000a56e:	078a                	slli	a5,a5,0x2
8000a570:	00fe1e33          	sll	t3,t3,a5
8000a574:	00f86833          	or	a6,a6,a5
8000a578:	01ee5713          	srli	a4,t3,0x1e
8000a57c:	00173713          	seqz	a4,a4
8000a580:	0706                	slli	a4,a4,0x1
8000a582:	00ee17b3          	sll	a5,t3,a4
8000a586:	00e86733          	or	a4,a6,a4
8000a58a:	fff7c793          	not	a5,a5
8000a58e:	83fd                	srli	a5,a5,0x1f
8000a590:	8f5d                	or	a4,a4,a5
8000a592:	00e697b3          	sll	a5,a3,a4
8000a596:	01f74813          	xori	a6,a4,31
8000a59a:	01035733          	srl	a4,t1,a6
8000a59e:	00e7efb3          	or	t6,a5,a4
8000a5a2:	001ff313          	andi	t1,t6,1
8000a5a6:	016fd713          	srli	a4,t6,0x16
8000a5aa:	0706                	slli	a4,a4,0x1
8000a5ac:	971e                	add	a4,a4,t2
8000a5ae:	c0075383          	lhu	t2,-1024(a4)
8000a5b2:	00bfd713          	srli	a4,t6,0xb
8000a5b6:	001fde13          	srli	t3,t6,0x1
8000a5ba:	00170e93          	addi	t4,a4,1
8000a5be:	02738733          	mul	a4,t2,t2
8000a5c2:	03d73eb3          	mulhu	t4,a4,t4
8000a5c6:	8f7e                	mv	t5,t6
8000a5c8:	9e1a                	add	t3,t3,t1
8000a5ca:	40600333          	neg	t1,t1
8000a5ce:	0392                	slli	t2,t2,0x4
8000a5d0:	fffec713          	not	a4,t4
8000a5d4:	93ba                	add	t2,t2,a4
8000a5d6:	0013d713          	srli	a4,t2,0x1
8000a5da:	00e37333          	and	t1,t1,a4
8000a5de:	87fe                	mv	a5,t6
8000a5e0:	03c38733          	mul	a4,t2,t3
8000a5e4:	40e30733          	sub	a4,t1,a4
8000a5e8:	00f39313          	slli	t1,t2,0xf
8000a5ec:	02e3b733          	mulhu	a4,t2,a4
8000a5f0:	8305                	srli	a4,a4,0x1
8000a5f2:	00e30e33          	add	t3,t1,a4
8000a5f6:	03fe0333          	mul	t1,t3,t6
8000a5fa:	03fe33b3          	mulhu	t2,t3,t6
8000a5fe:	9f1a                	add	t5,t5,t1
8000a600:	006f3733          	sltu	a4,t5,t1
8000a604:	97ba                	add	a5,a5,a4
8000a606:	979e                	add	a5,a5,t2
8000a608:	40fe0733          	sub	a4,t3,a5
8000a60c:	03173333          	mulhu	t1,a4,a7
8000a610:	03170733          	mul	a4,a4,a7
8000a614:	00e283b3          	add	t2,t0,a4
8000a618:	0053b7b3          	sltu	a5,t2,t0
8000a61c:	989a                	add	a7,a7,t1
8000a61e:	00f88333          	add	t1,a7,a5
8000a622:	00130893          	addi	a7,t1,1 # 7f800001 <__NONCACHEABLE_RAM_segment_end__+0x7e5c0001>
8000a626:	03f887b3          	mul	a5,a7,t6
8000a62a:	40f287b3          	sub	a5,t0,a5
8000a62e:	00f3b733          	sltu	a4,t2,a5
8000a632:	40e00733          	neg	a4,a4
8000a636:	01f772b3          	and	t0,a4,t6
8000a63a:	92be                	add	t0,t0,a5
8000a63c:	00f3e363          	bltu	t2,a5,8000a642 <__udivdi3+0x164>
8000a640:	8346                	mv	t1,a7
8000a642:	01f2b733          	sltu	a4,t0,t6
8000a646:	00174713          	xori	a4,a4,1
8000a64a:	971a                	add	a4,a4,t1
8000a64c:	01075733          	srl	a4,a4,a6
8000a650:	fff70793          	addi	a5,a4,-1
8000a654:	00f73733          	sltu	a4,a4,a5
8000a658:	177d                	addi	a4,a4,-1
8000a65a:	8ff9                	and	a5,a5,a4
8000a65c:	02f68833          	mul	a6,a3,a5
8000a660:	02f638b3          	mulhu	a7,a2,a5
8000a664:	02f60733          	mul	a4,a2,a5
8000a668:	9846                	add	a6,a6,a7
8000a66a:	41058833          	sub	a6,a1,a6
8000a66e:	00e535b3          	sltu	a1,a0,a4
8000a672:	40b805b3          	sub	a1,a6,a1
8000a676:	12d58163          	beq	a1,a3,8000a798 <__udivdi3+0x2ba>
8000a67a:	00d5b533          	sltu	a0,a1,a3
8000a67e:	a205                	j	8000a79e <__udivdi3+0x2c0>
8000a680:	10070963          	beqz	a4,8000a792 <__udivdi3+0x2b4>
8000a684:	12c77463          	bgeu	a4,a2,8000a7ac <__udivdi3+0x2ce>
8000a688:	01065693          	srli	a3,a2,0x10
8000a68c:	00155893          	srli	a7,a0,0x1
8000a690:	8000b837          	lui	a6,0x8000b
8000a694:	9ca80813          	addi	a6,a6,-1590 # 8000a9ca <__SEGGER_RTL_Moeller_inverse_lut>
8000a698:	0016b693          	seqz	a3,a3
8000a69c:	0692                	slli	a3,a3,0x4
8000a69e:	00d61733          	sll	a4,a2,a3
8000a6a2:	01875793          	srli	a5,a4,0x18
8000a6a6:	0017b793          	seqz	a5,a5
8000a6aa:	078e                	slli	a5,a5,0x3
8000a6ac:	00f71733          	sll	a4,a4,a5
8000a6b0:	8edd                	or	a3,a3,a5
8000a6b2:	01c75793          	srli	a5,a4,0x1c
8000a6b6:	0017b793          	seqz	a5,a5
8000a6ba:	078a                	slli	a5,a5,0x2
8000a6bc:	00f71733          	sll	a4,a4,a5
8000a6c0:	8edd                	or	a3,a3,a5
8000a6c2:	01e75793          	srli	a5,a4,0x1e
8000a6c6:	0017b793          	seqz	a5,a5
8000a6ca:	0786                	slli	a5,a5,0x1
8000a6cc:	00f71733          	sll	a4,a4,a5
8000a6d0:	8edd                	or	a3,a3,a5
8000a6d2:	fff74713          	not	a4,a4
8000a6d6:	837d                	srli	a4,a4,0x1f
8000a6d8:	8ed9                	or	a3,a3,a4
8000a6da:	00d59733          	sll	a4,a1,a3
8000a6de:	01f6c793          	xori	a5,a3,31
8000a6e2:	00d512b3          	sll	t0,a0,a3
8000a6e6:	00d616b3          	sll	a3,a2,a3
8000a6ea:	00f8d633          	srl	a2,a7,a5
8000a6ee:	0016f593          	andi	a1,a3,1
8000a6f2:	00b6d793          	srli	a5,a3,0xb
8000a6f6:	0166d513          	srli	a0,a3,0x16
8000a6fa:	0506                	slli	a0,a0,0x1
8000a6fc:	9542                	add	a0,a0,a6
8000a6fe:	c0055503          	lhu	a0,-1024(a0)
8000a702:	0016d813          	srli	a6,a3,0x1
8000a706:	00c768b3          	or	a7,a4,a2
8000a70a:	0785                	addi	a5,a5,1 # 800001 <__DLM_segment_end__+0x5e0001>
8000a70c:	02a50733          	mul	a4,a0,a0
8000a710:	02f73733          	mulhu	a4,a4,a5
8000a714:	87b6                	mv	a5,a3
8000a716:	982e                	add	a6,a6,a1
8000a718:	40b005b3          	neg	a1,a1
8000a71c:	0512                	slli	a0,a0,0x4
8000a71e:	fff74713          	not	a4,a4
8000a722:	953a                	add	a0,a0,a4
8000a724:	00155713          	srli	a4,a0,0x1
8000a728:	8df9                	and	a1,a1,a4
8000a72a:	8736                	mv	a4,a3
8000a72c:	03050633          	mul	a2,a0,a6
8000a730:	8d91                	sub	a1,a1,a2
8000a732:	00f51613          	slli	a2,a0,0xf
8000a736:	02b53533          	mulhu	a0,a0,a1
8000a73a:	8105                	srli	a0,a0,0x1
8000a73c:	9532                	add	a0,a0,a2
8000a73e:	02d505b3          	mul	a1,a0,a3
8000a742:	02d53633          	mulhu	a2,a0,a3
8000a746:	97ae                	add	a5,a5,a1
8000a748:	00b7b5b3          	sltu	a1,a5,a1
8000a74c:	972e                	add	a4,a4,a1
8000a74e:	9732                	add	a4,a4,a2
8000a750:	8d19                	sub	a0,a0,a4
8000a752:	031535b3          	mulhu	a1,a0,a7
8000a756:	03150533          	mul	a0,a0,a7
8000a75a:	00a28733          	add	a4,t0,a0
8000a75e:	00573533          	sltu	a0,a4,t0
8000a762:	95c6                	add	a1,a1,a7
8000a764:	952e                	add	a0,a0,a1
8000a766:	00150613          	addi	a2,a0,1
8000a76a:	02d605b3          	mul	a1,a2,a3
8000a76e:	40b287b3          	sub	a5,t0,a1
8000a772:	00f735b3          	sltu	a1,a4,a5
8000a776:	40b005b3          	neg	a1,a1
8000a77a:	8df5                	and	a1,a1,a3
8000a77c:	95be                	add	a1,a1,a5
8000a77e:	00f76363          	bltu	a4,a5,8000a784 <__udivdi3+0x2a6>
8000a782:	8532                	mv	a0,a2
8000a784:	4701                	li	a4,0
8000a786:	00d5b5b3          	sltu	a1,a1,a3
8000a78a:	0015c693          	xori	a3,a1,1
8000a78e:	96aa                	add	a3,a3,a0
8000a790:	a819                	j	8000a7a6 <__udivdi3+0x2c8>
8000a792:	02c556b3          	divu	a3,a0,a2
8000a796:	a801                	j	8000a7a6 <__udivdi3+0x2c8>
8000a798:	8d19                	sub	a0,a0,a4
8000a79a:	00c53533          	sltu	a0,a0,a2
8000a79e:	4701                	li	a4,0
8000a7a0:	00154693          	xori	a3,a0,1
8000a7a4:	96be                	add	a3,a3,a5
8000a7a6:	8536                	mv	a0,a3
8000a7a8:	85ba                	mv	a1,a4
8000a7aa:	8082                	ret
8000a7ac:	02c758b3          	divu	a7,a4,a2
8000a7b0:	01065693          	srli	a3,a2,0x10
8000a7b4:	00155293          	srli	t0,a0,0x1
8000a7b8:	8000b837          	lui	a6,0x8000b
8000a7bc:	9ca80813          	addi	a6,a6,-1590 # 8000a9ca <__SEGGER_RTL_Moeller_inverse_lut>
8000a7c0:	0016b693          	seqz	a3,a3
8000a7c4:	02c885b3          	mul	a1,a7,a2
8000a7c8:	0692                	slli	a3,a3,0x4
8000a7ca:	8f0d                	sub	a4,a4,a1
8000a7cc:	00d617b3          	sll	a5,a2,a3
8000a7d0:	0187d593          	srli	a1,a5,0x18
8000a7d4:	0015b593          	seqz	a1,a1
8000a7d8:	058e                	slli	a1,a1,0x3
8000a7da:	00b797b3          	sll	a5,a5,a1
8000a7de:	8dd5                	or	a1,a1,a3
8000a7e0:	01c7d693          	srli	a3,a5,0x1c
8000a7e4:	0016b693          	seqz	a3,a3
8000a7e8:	068a                	slli	a3,a3,0x2
8000a7ea:	00d797b3          	sll	a5,a5,a3
8000a7ee:	8dd5                	or	a1,a1,a3
8000a7f0:	01e7d693          	srli	a3,a5,0x1e
8000a7f4:	0016b693          	seqz	a3,a3
8000a7f8:	0686                	slli	a3,a3,0x1
8000a7fa:	00d797b3          	sll	a5,a5,a3
8000a7fe:	8dd5                	or	a1,a1,a3
8000a800:	fff7c693          	not	a3,a5
8000a804:	82fd                	srli	a3,a3,0x1f
8000a806:	8dd5                	or	a1,a1,a3
8000a808:	00b71733          	sll	a4,a4,a1
8000a80c:	01f5c793          	xori	a5,a1,31
8000a810:	00b51333          	sll	t1,a0,a1
8000a814:	00b61633          	sll	a2,a2,a1
8000a818:	00f2d5b3          	srl	a1,t0,a5
8000a81c:	00167693          	andi	a3,a2,1
8000a820:	00b65793          	srli	a5,a2,0xb
8000a824:	01665513          	srli	a0,a2,0x16
8000a828:	0506                	slli	a0,a0,0x1
8000a82a:	9542                	add	a0,a0,a6
8000a82c:	c0055503          	lhu	a0,-1024(a0)
8000a830:	00165813          	srli	a6,a2,0x1
8000a834:	00b762b3          	or	t0,a4,a1
8000a838:	0785                	addi	a5,a5,1
8000a83a:	02a50733          	mul	a4,a0,a0
8000a83e:	02f73733          	mulhu	a4,a4,a5
8000a842:	87b2                	mv	a5,a2
8000a844:	9836                	add	a6,a6,a3
8000a846:	40d006b3          	neg	a3,a3
8000a84a:	0512                	slli	a0,a0,0x4
8000a84c:	fff74713          	not	a4,a4
8000a850:	953a                	add	a0,a0,a4
8000a852:	00155713          	srli	a4,a0,0x1
8000a856:	8ef9                	and	a3,a3,a4
8000a858:	8732                	mv	a4,a2
8000a85a:	030505b3          	mul	a1,a0,a6
8000a85e:	8e8d                	sub	a3,a3,a1
8000a860:	00f51593          	slli	a1,a0,0xf
8000a864:	02d53533          	mulhu	a0,a0,a3
8000a868:	8105                	srli	a0,a0,0x1
8000a86a:	952e                	add	a0,a0,a1
8000a86c:	02c505b3          	mul	a1,a0,a2
8000a870:	02c536b3          	mulhu	a3,a0,a2
8000a874:	97ae                	add	a5,a5,a1
8000a876:	00b7b5b3          	sltu	a1,a5,a1
8000a87a:	972e                	add	a4,a4,a1
8000a87c:	9736                	add	a4,a4,a3
8000a87e:	8d19                	sub	a0,a0,a4
8000a880:	025535b3          	mulhu	a1,a0,t0
8000a884:	02550533          	mul	a0,a0,t0
8000a888:	00a307b3          	add	a5,t1,a0
8000a88c:	0067b533          	sltu	a0,a5,t1
8000a890:	9596                	add	a1,a1,t0
8000a892:	952e                	add	a0,a0,a1
8000a894:	00150713          	addi	a4,a0,1
8000a898:	02c705b3          	mul	a1,a4,a2
8000a89c:	40b305b3          	sub	a1,t1,a1
8000a8a0:	00b7b6b3          	sltu	a3,a5,a1
8000a8a4:	40d006b3          	neg	a3,a3
8000a8a8:	8ef1                	and	a3,a3,a2
8000a8aa:	96ae                	add	a3,a3,a1
8000a8ac:	00b7e363          	bltu	a5,a1,8000a8b2 <__udivdi3+0x3d4>
8000a8b0:	853a                	mv	a0,a4
8000a8b2:	00c6b5b3          	sltu	a1,a3,a2
8000a8b6:	0015c693          	xori	a3,a1,1
8000a8ba:	96aa                	add	a3,a3,a0
8000a8bc:	8746                	mv	a4,a7
8000a8be:	b5e5                	j	8000a7a6 <__udivdi3+0x2c8>
8000a8c0:	01065793          	srli	a5,a2,0x10
8000a8c4:	02c5d733          	divu	a4,a1,a2
8000a8c8:	8edd                	or	a3,a3,a5
8000a8ca:	02c707b3          	mul	a5,a4,a2
8000a8ce:	8d9d                	sub	a1,a1,a5
8000a8d0:	e6a9                	bnez	a3,8000a91a <__udivdi3+0x43c>
8000a8d2:	01055693          	srli	a3,a0,0x10
8000a8d6:	05c2                	slli	a1,a1,0x10
8000a8d8:	0542                	slli	a0,a0,0x10
8000a8da:	8dd5                	or	a1,a1,a3
8000a8dc:	8141                	srli	a0,a0,0x10
8000a8de:	02c5d5b3          	divu	a1,a1,a2
8000a8e2:	02c587b3          	mul	a5,a1,a2
8000a8e6:	8e9d                	sub	a3,a3,a5
8000a8e8:	06c2                	slli	a3,a3,0x10
8000a8ea:	8d55                	or	a0,a0,a3
8000a8ec:	02c556b3          	divu	a3,a0,a2
8000a8f0:	05c2                	slli	a1,a1,0x10
8000a8f2:	96ae                	add	a3,a3,a1
8000a8f4:	00b6b533          	sltu	a0,a3,a1
8000a8f8:	972a                	add	a4,a4,a0
8000a8fa:	b575                	j	8000a7a6 <__udivdi3+0x2c8>
8000a8fc:	468d                	li	a3,3
8000a8fe:	06d60d63          	beq	a2,a3,8000a978 <__udivdi3+0x49a>
8000a902:	4681                	li	a3,0
8000a904:	4791                	li	a5,4
8000a906:	4701                	li	a4,0
8000a908:	e8f61fe3          	bne	a2,a5,8000a7a6 <__udivdi3+0x2c8>
8000a90c:	8109                	srli	a0,a0,0x2
8000a90e:	01e59693          	slli	a3,a1,0x1e
8000a912:	8ec9                	or	a3,a3,a0
8000a914:	0025d713          	srli	a4,a1,0x2
8000a918:	b579                	j	8000a7a6 <__udivdi3+0x2c8>
8000a91a:	01855813          	srli	a6,a0,0x18
8000a91e:	05a2                	slli	a1,a1,0x8
8000a920:	00851793          	slli	a5,a0,0x8
8000a924:	01051693          	slli	a3,a0,0x10
8000a928:	0ff57893          	zext.b	a7,a0
8000a92c:	0105e5b3          	or	a1,a1,a6
8000a930:	83e1                	srli	a5,a5,0x18
8000a932:	0186d813          	srli	a6,a3,0x18
8000a936:	02c5d533          	divu	a0,a1,a2
8000a93a:	02c506b3          	mul	a3,a0,a2
8000a93e:	0562                	slli	a0,a0,0x18
8000a940:	8d95                	sub	a1,a1,a3
8000a942:	05a2                	slli	a1,a1,0x8
8000a944:	8ddd                	or	a1,a1,a5
8000a946:	02c5d6b3          	divu	a3,a1,a2
8000a94a:	02c687b3          	mul	a5,a3,a2
8000a94e:	06c2                	slli	a3,a3,0x10
8000a950:	8d9d                	sub	a1,a1,a5
8000a952:	9536                	add	a0,a0,a3
8000a954:	05a2                	slli	a1,a1,0x8
8000a956:	0105e5b3          	or	a1,a1,a6
8000a95a:	02c5d6b3          	divu	a3,a1,a2
8000a95e:	02c687b3          	mul	a5,a3,a2
8000a962:	06a2                	slli	a3,a3,0x8
8000a964:	8d9d                	sub	a1,a1,a5
8000a966:	05a2                	slli	a1,a1,0x8
8000a968:	0115e5b3          	or	a1,a1,a7
8000a96c:	02c5d5b3          	divu	a1,a1,a2
8000a970:	9536                	add	a0,a0,a3
8000a972:	00b506b3          	add	a3,a0,a1
8000a976:	bd05                	j	8000a7a6 <__udivdi3+0x2c8>
8000a978:	555555b7          	lui	a1,0x55555
8000a97c:	55558593          	addi	a1,a1,1365 # 55555555 <__NONCACHEABLE_RAM_segment_end__+0x54315555>
8000a980:	02a5b633          	mulhu	a2,a1,a0
8000a984:	02a58533          	mul	a0,a1,a0
8000a988:	02e5b6b3          	mulhu	a3,a1,a4
8000a98c:	02e585b3          	mul	a1,a1,a4
8000a990:	962e                	add	a2,a2,a1
8000a992:	00b635b3          	sltu	a1,a2,a1
8000a996:	9532                	add	a0,a0,a2
8000a998:	95b6                	add	a1,a1,a3
8000a99a:	00c536b3          	sltu	a3,a0,a2
8000a99e:	96ae                	add	a3,a3,a1
8000a9a0:	00d60733          	add	a4,a2,a3
8000a9a4:	9536                	add	a0,a0,a3
8000a9a6:	00c73633          	sltu	a2,a4,a2
8000a9aa:	00d536b3          	sltu	a3,a0,a3
8000a9ae:	0505                	addi	a0,a0,1
8000a9b0:	95b2                	add	a1,a1,a2
8000a9b2:	00d70633          	add	a2,a4,a3
8000a9b6:	00153693          	seqz	a3,a0
8000a9ba:	00e63533          	sltu	a0,a2,a4
8000a9be:	96b2                	add	a3,a3,a2
8000a9c0:	952e                	add	a0,a0,a1
8000a9c2:	00c6b733          	sltu	a4,a3,a2
8000a9c6:	972a                	add	a4,a4,a0
8000a9c8:	bbf9                	j	8000a7a6 <__udivdi3+0x2c8>

Disassembly of section .text.libc.memset:

8000adca <memset>:
8000adca:	872a                	mv	a4,a0
8000adcc:	c22d                	beqz	a2,8000ae2e <.Lmemset_memset_end>

8000adce <.Lmemset_unaligned_byte_set_loop>:
8000adce:	01e51693          	slli	a3,a0,0x1e
8000add2:	c699                	beqz	a3,8000ade0 <.Lmemset_fast_set>
8000add4:	00b50023          	sb	a1,0(a0)
8000add8:	0505                	addi	a0,a0,1
8000adda:	167d                	addi	a2,a2,-1 # ff7fffff <__AHB_SRAM_segment_end__+0xf5f7fff>
8000addc:	fa6d                	bnez	a2,8000adce <.Lmemset_unaligned_byte_set_loop>
8000adde:	a881                	j	8000ae2e <.Lmemset_memset_end>

8000ade0 <.Lmemset_fast_set>:
8000ade0:	0ff5f593          	zext.b	a1,a1
8000ade4:	00859693          	slli	a3,a1,0x8
8000ade8:	8dd5                	or	a1,a1,a3
8000adea:	01059693          	slli	a3,a1,0x10
8000adee:	8dd5                	or	a1,a1,a3
8000adf0:	02000693          	li	a3,32
8000adf4:	00d66f63          	bltu	a2,a3,8000ae12 <.Lmemset_word_set>

8000adf8 <.Lmemset_fast_set_loop>:
8000adf8:	c10c                	sw	a1,0(a0)
8000adfa:	c14c                	sw	a1,4(a0)
8000adfc:	c50c                	sw	a1,8(a0)
8000adfe:	c54c                	sw	a1,12(a0)
8000ae00:	c90c                	sw	a1,16(a0)
8000ae02:	c94c                	sw	a1,20(a0)
8000ae04:	cd0c                	sw	a1,24(a0)
8000ae06:	cd4c                	sw	a1,28(a0)
8000ae08:	9536                	add	a0,a0,a3
8000ae0a:	8e15                	sub	a2,a2,a3
8000ae0c:	fed676e3          	bgeu	a2,a3,8000adf8 <.Lmemset_fast_set_loop>
8000ae10:	ce19                	beqz	a2,8000ae2e <.Lmemset_memset_end>

8000ae12 <.Lmemset_word_set>:
8000ae12:	4691                	li	a3,4
8000ae14:	00d66863          	bltu	a2,a3,8000ae24 <.Lmemset_byte_set_loop>

8000ae18 <.Lmemset_word_set_loop>:
8000ae18:	c10c                	sw	a1,0(a0)
8000ae1a:	9536                	add	a0,a0,a3
8000ae1c:	8e15                	sub	a2,a2,a3
8000ae1e:	fed67de3          	bgeu	a2,a3,8000ae18 <.Lmemset_word_set_loop>
8000ae22:	c611                	beqz	a2,8000ae2e <.Lmemset_memset_end>

8000ae24 <.Lmemset_byte_set_loop>:
8000ae24:	00b50023          	sb	a1,0(a0)
8000ae28:	0505                	addi	a0,a0,1
8000ae2a:	167d                	addi	a2,a2,-1
8000ae2c:	fe65                	bnez	a2,8000ae24 <.Lmemset_byte_set_loop>

8000ae2e <.Lmemset_memset_end>:
8000ae2e:	853a                	mv	a0,a4
8000ae30:	8082                	ret

Disassembly of section .text.libc.strlen:

8000ae32 <strlen>:
8000ae32:	85aa                	mv	a1,a0
8000ae34:	00357693          	andi	a3,a0,3
8000ae38:	c29d                	beqz	a3,8000ae5e <.Lstrlen_aligned>
8000ae3a:	00054603          	lbu	a2,0(a0)
8000ae3e:	ce21                	beqz	a2,8000ae96 <.Lstrlen_done>
8000ae40:	0505                	addi	a0,a0,1
8000ae42:	00357693          	andi	a3,a0,3
8000ae46:	ce81                	beqz	a3,8000ae5e <.Lstrlen_aligned>
8000ae48:	00054603          	lbu	a2,0(a0)
8000ae4c:	c629                	beqz	a2,8000ae96 <.Lstrlen_done>
8000ae4e:	0505                	addi	a0,a0,1
8000ae50:	00357693          	andi	a3,a0,3
8000ae54:	c689                	beqz	a3,8000ae5e <.Lstrlen_aligned>
8000ae56:	00054603          	lbu	a2,0(a0)
8000ae5a:	ce15                	beqz	a2,8000ae96 <.Lstrlen_done>
8000ae5c:	0505                	addi	a0,a0,1

8000ae5e <.Lstrlen_aligned>:
8000ae5e:	01010637          	lui	a2,0x1010
8000ae62:	10160613          	addi	a2,a2,257 # 1010101 <__DLM_segment_end__+0xdf0101>
8000ae66:	00761693          	slli	a3,a2,0x7

8000ae6a <.Lstrlen_wordstrlen>:
8000ae6a:	4118                	lw	a4,0(a0)
8000ae6c:	0511                	addi	a0,a0,4
8000ae6e:	40c707b3          	sub	a5,a4,a2
8000ae72:	fff74713          	not	a4,a4
8000ae76:	8ff9                	and	a5,a5,a4
8000ae78:	8ff5                	and	a5,a5,a3
8000ae7a:	dbe5                	beqz	a5,8000ae6a <.Lstrlen_wordstrlen>
8000ae7c:	1571                	addi	a0,a0,-4
8000ae7e:	01879713          	slli	a4,a5,0x18
8000ae82:	eb11                	bnez	a4,8000ae96 <.Lstrlen_done>
8000ae84:	0505                	addi	a0,a0,1
8000ae86:	01079713          	slli	a4,a5,0x10
8000ae8a:	e711                	bnez	a4,8000ae96 <.Lstrlen_done>
8000ae8c:	0505                	addi	a0,a0,1
8000ae8e:	00879713          	slli	a4,a5,0x8
8000ae92:	e311                	bnez	a4,8000ae96 <.Lstrlen_done>
8000ae94:	0505                	addi	a0,a0,1

8000ae96 <.Lstrlen_done>:
8000ae96:	8d0d                	sub	a0,a0,a1
8000ae98:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

8000ae9a <__SEGGER_RTL_pow10f>:
8000ae9a:	1101                	addi	sp,sp,-32
8000ae9c:	ce06                	sw	ra,28(sp)
8000ae9e:	cc22                	sw	s0,24(sp)
8000aea0:	ca26                	sw	s1,20(sp)
8000aea2:	c84a                	sw	s2,16(sp)
8000aea4:	c64e                	sw	s3,12(sp)
8000aea6:	892a                	mv	s2,a0
8000aea8:	c515                	beqz	a0,8000aed4 <__SEGGER_RTL_pow10f+0x3a>
8000aeaa:	41f95513          	srai	a0,s2,0x1f
8000aeae:	c5c18413          	addi	s0,gp,-932 # 80003d90 <__SEGGER_RTL_aPower2f>
8000aeb2:	00a944b3          	xor	s1,s2,a0
8000aeb6:	8c89                	sub	s1,s1,a0
8000aeb8:	3f8009b7          	lui	s3,0x3f800
8000aebc:	0014f513          	andi	a0,s1,1
8000aec0:	c511                	beqz	a0,8000aecc <__SEGGER_RTL_pow10f+0x32>
8000aec2:	400c                	lw	a1,0(s0)
8000aec4:	854e                	mv	a0,s3
8000aec6:	92aff0ef          	jal	80009ff0 <__mulsf3>
8000aeca:	89aa                	mv	s3,a0
8000aecc:	8085                	srli	s1,s1,0x1
8000aece:	0411                	addi	s0,s0,4
8000aed0:	f4f5                	bnez	s1,8000aebc <__SEGGER_RTL_pow10f+0x22>
8000aed2:	a019                	j	8000aed8 <__SEGGER_RTL_pow10f+0x3e>
8000aed4:	3f8009b7          	lui	s3,0x3f800
8000aed8:	3f800537          	lui	a0,0x3f800
8000aedc:	85ce                	mv	a1,s3
8000aede:	9c2ff0ef          	jal	8000a0a0 <__divsf3>
8000aee2:	00094363          	bltz	s2,8000aee8 <__SEGGER_RTL_pow10f+0x4e>
8000aee6:	854e                	mv	a0,s3
8000aee8:	40f2                	lw	ra,28(sp)
8000aeea:	4462                	lw	s0,24(sp)
8000aeec:	44d2                	lw	s1,20(sp)
8000aeee:	4942                	lw	s2,16(sp)
8000aef0:	49b2                	lw	s3,12(sp)
8000aef2:	6105                	addi	sp,sp,32
8000aef4:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

8000aef6 <__SEGGER_RTL_current_locale>:
8000aef6:	00000537          	lui	a0,0x0
8000aefa:	00450533          	add	a0,a0,tp
8000aefe:	00052503          	lw	a0,0(a0) # 0 <__AHB_SRAM_segment_used_size__>
8000af02:	e519                	bnez	a0,8000af10 <__SEGGER_RTL_current_locale+0x1a>
8000af04:	00000537          	lui	a0,0x0
8000af08:	00450533          	add	a0,a0,tp
8000af0c:	00450513          	addi	a0,a0,4 # 4 <__AHB_SRAM_segment_used_size__+0x4>
8000af10:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

8000af12 <__SEGGER_RTL_ascii_mbtowc>:
8000af12:	4701                	li	a4,0
8000af14:	c19d                	beqz	a1,8000af3a <__SEGGER_RTL_ascii_mbtowc+0x28>
8000af16:	c215                	beqz	a2,8000af3a <__SEGGER_RTL_ascii_mbtowc+0x28>
8000af18:	0005c603          	lbu	a2,0(a1)
8000af1c:	01861593          	slli	a1,a2,0x18
8000af20:	0005cc63          	bltz	a1,8000af38 <__SEGGER_RTL_ascii_mbtowc+0x26>
8000af24:	85e1                	srai	a1,a1,0x18
8000af26:	c111                	beqz	a0,8000af2a <__SEGGER_RTL_ascii_mbtowc+0x18>
8000af28:	c110                	sw	a2,0(a0)
8000af2a:	0006a023          	sw	zero,0(a3) # 800000 <__DLM_segment_end__+0x5e0000>
8000af2e:	0006a223          	sw	zero,4(a3)
8000af32:	00b03733          	snez	a4,a1
8000af36:	a011                	j	8000af3a <__SEGGER_RTL_ascii_mbtowc+0x28>
8000af38:	5779                	li	a4,-2
8000af3a:	853a                	mv	a0,a4
8000af3c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

8000af3e <__SEGGER_RTL_ascii_wctomb>:
8000af3e:	07f00613          	li	a2,127
8000af42:	00b67463          	bgeu	a2,a1,8000af4a <__SEGGER_RTL_ascii_wctomb+0xc>
8000af46:	5579                	li	a0,-2
8000af48:	8082                	ret
8000af4a:	00b50023          	sb	a1,0(a0)
8000af4e:	4505                	li	a0,1
8000af50:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

8000af52 <__SEGGER_RTL_ascii_isctype>:
8000af52:	07f00613          	li	a2,127
8000af56:	02a66263          	bltu	a2,a0,8000af7a <__SEGGER_RTL_ascii_isctype+0x28>
8000af5a:	8000b637          	lui	a2,0x8000b
8000af5e:	29860613          	addi	a2,a2,664 # 8000b298 <__SEGGER_RTL_ascii_ctype_map>
8000af62:	9532                	add	a0,a0,a2
8000af64:	8000b637          	lui	a2,0x8000b
8000af68:	0ce60613          	addi	a2,a2,206 # 8000b0ce <__SEGGER_RTL_ascii_ctype_mask>
8000af6c:	95b2                	add	a1,a1,a2
8000af6e:	00054503          	lbu	a0,0(a0)
8000af72:	0005c583          	lbu	a1,0(a1)
8000af76:	8d6d                	and	a0,a0,a1
8000af78:	8082                	ret
8000af7a:	4501                	li	a0,0
8000af7c:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

8000af7e <__SEGGER_RTL_ascii_iswctype>:
8000af7e:	07f00613          	li	a2,127
8000af82:	02a66263          	bltu	a2,a0,8000afa6 <__SEGGER_RTL_ascii_iswctype+0x28>
8000af86:	8000b637          	lui	a2,0x8000b
8000af8a:	29860613          	addi	a2,a2,664 # 8000b298 <__SEGGER_RTL_ascii_ctype_map>
8000af8e:	9532                	add	a0,a0,a2
8000af90:	8000b637          	lui	a2,0x8000b
8000af94:	0ce60613          	addi	a2,a2,206 # 8000b0ce <__SEGGER_RTL_ascii_ctype_mask>
8000af98:	95b2                	add	a1,a1,a2
8000af9a:	00054503          	lbu	a0,0(a0)
8000af9e:	0005c583          	lbu	a1,0(a1)
8000afa2:	8d6d                	and	a0,a0,a1
8000afa4:	8082                	ret
8000afa6:	4501                	li	a0,0
8000afa8:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

8000b9c4 <__SEGGER_init_zero>:
8000b9c4:	4008                	lw	a0,0(s0)
8000b9c6:	404c                	lw	a1,4(s0)
8000b9c8:	0421                	addi	s0,s0,8
8000b9ca:	c591                	beqz	a1,8000b9d6 <.L__SEGGER_init_zero_Done>

8000b9cc <.L__SEGGER_init_zero_Loop>:
8000b9cc:	00050023          	sb	zero,0(a0)
8000b9d0:	0505                	addi	a0,a0,1
8000b9d2:	15fd                	addi	a1,a1,-1
8000b9d4:	fde5                	bnez	a1,8000b9cc <.L__SEGGER_init_zero_Loop>

8000b9d6 <.L__SEGGER_init_zero_Done>:
8000b9d6:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

8000b9d8 <__SEGGER_init_copy>:
8000b9d8:	4008                	lw	a0,0(s0)
8000b9da:	404c                	lw	a1,4(s0)
8000b9dc:	4410                	lw	a2,8(s0)
8000b9de:	0431                	addi	s0,s0,12
8000b9e0:	ca09                	beqz	a2,8000b9f2 <.L__SEGGER_init_copy_Done>

8000b9e2 <.L__SEGGER_init_copy_Loop>:
8000b9e2:	00058683          	lb	a3,0(a1)
8000b9e6:	00d50023          	sb	a3,0(a0)
8000b9ea:	0505                	addi	a0,a0,1
8000b9ec:	0585                	addi	a1,a1,1
8000b9ee:	167d                	addi	a2,a2,-1
8000b9f0:	fa6d                	bnez	a2,8000b9e2 <.L__SEGGER_init_copy_Loop>

8000b9f2 <.L__SEGGER_init_copy_Done>:
8000b9f2:	8082                	ret
