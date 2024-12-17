.text
	li    s0, 0x12345678      # Example value for s0
	srli  t0, s0, 24          # Extract MSB (shift right logical by 24 bits)
	andi  t1, s0, 0xFFFFFF00  # Clear LSB (mask out LSB by ANDing with 0xFFFFFF00)
	ori   t2, s0, 0x000000FF  # Set LSB (OR with 0xFF to set bits 7 to 0)
	li    s0, 0               # Clear register s0 (set s0 to 0)
	