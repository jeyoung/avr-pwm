#include <avr/io.h>
#include <util/delay.h>

/* 2 ms -> 250 cycles */
#define MAX_DUTY_CYCLE 250

#define MIN_PULSE 32
#define MAX_PULSE 250
#define STEPS 10

void
delay_ms(uint16_t ms);

void
main(void)
{
	DDRB  |= (1 << PB4);
	TCCR1 |= (1 << CTC1);

	/* CK/8 -> 0.002 second period */
	TCCR1 |= (1 << CS12);
	GTCCR |= (1 << PWM1B) | (1 << COM1B1) & ~(1 << COM1B0);

	OCR1C  = MAX_DUTY_CYCLE;

	volatile float step = (MAX_PULSE-MIN_PULSE) * (-1.0f/STEPS);
	volatile float pulse = MIN_PULSE;

	while (1) {
		OCR1B = pulse;

		pulse += step;
		if (pulse < MIN_PULSE || pulse > MAX_PULSE)
			step *= -1;

		if (pulse < MIN_PULSE)
			pulse = MIN_PULSE;
		if (pulse > MAX_PULSE)
			pulse = MAX_PULSE;

		delay_ms(100);
	}
}

void
delay_ms(uint16_t ms)
{
	while (--ms > 0)
		_delay_ms(1);
}
