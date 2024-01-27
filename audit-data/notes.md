There is no setup() included in the test suite `test/MathMasters.t.sol`
This is probably because there is no state to be initialized into storage
(no constructor)

# 1 What do we want to prove/disprove?

When calculation within sqrt() overflows scratch memory (64 bytes), the free memory pointer, falsely points at it's latest updated location (it does not get updated outside the 64 byte scratch memory.) Any subsequent operation, will write over previous memory data starting from where the free memory pointer last got updated. 