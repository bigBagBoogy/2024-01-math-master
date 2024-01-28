There is no setup() included in the test suite `test/MathMasters.t.sol`
This is probably because there is no state to be initialized into storage
(no constructor)

In the provided test suite, since the MathMasters contract does not have a constructor and there are no specific initialization steps required before running each test case, the authors have chosen to omit the setUp() function. This helps keep the test code concise and focused on the actual test cases.

# 1 What do we want to prove/disprove?

When calculation within sqrt() overflows scratch memory (64 bytes), the free memory pointer, falsely points at it's latest updated location (it does not get updated outside the 64 byte scratch memory.) Any subsequent operation, will write over previous memory data starting from where the free memory pointer last got updated. 

The problem with running the `check_sqrtCalculationBreaksOnMemory` formal verification test is the `path-explosion issue`.
Running all possible numbers that a uint256 holds through the square root function is just too much.
On this, the test will fail instead of the function itself.

# Notes on Memory:
***Layout in Memory:***
Solidity reserves certain sections of memory for specific purposes. These sections are defined by byte ranges.

### Scratch Space (0x00 - 0x3f):
***In hexadecimal notation, 0x3f represents the number 63 in decimal.***

This area is used as temporary storage for calculations, particularly for hashing methods.
It's like a whiteboard where you can perform calculations between steps, especially when using inline assembly.
### Currently Allocated Memory Size (0x40 - 0x5f):
***In hexadecimal notation, 0x40 represents the number 64 in decimal.***
***In hexadecimal notation, 0x5f represents the number 95 in decimal.***
Above range in memory represents the 32 bytes (64 - 95 (64 included)) of free memory pointer.

***so the complete memory allocation in solidity:***
0x00 - 0x3f: Addresses 0 to 63. (64 bytes scratch space)
0x40 - 0x5f: Addresses 64 to 95. (32 bytes free memory pointer)
0x60 - 0x7f: Addresses 96 to 127. (32 bytes zero slot)


This section stores the current size of memory that has been allocated.
It's like a counter that keeps track of how much memory has been used, particularly for dynamically-sized data structures like arrays.
### Zero Slot (0x60 - 0x7f):

This slot always contains a zero value.
It's used as the initial value for dynamic memory arrays, which are arrays whose size can change during execution.
It's important not to write to this slot because it serves a specific purpose for dynamic memory arrays.
Memory Management:

Solidity always places new objects (like variables or arrays) at the free memory pointer.
Memory is never freed (released back to the system) in Solidity, at least for now. This may change in the future.
Memory Arrays:

Elements in memory arrays always occupy multiples of 32 bytes. This means that each element is aligned to a 32-byte boundary.
Even single-byte elements (like bytes1) are padded to occupy 32 bytes each, except for bytes and string types.
Multi-dimensional memory arrays are represented as pointers to memory arrays.
The length of a dynamic array is stored at the beginning of the array, followed by the array elements.
Warning:

Some operations in Solidity require a temporary memory area larger than the scratch space (larger than 64 bytes). These operations are placed where the free memory points to.
The free memory pointer is not always updated for these operations, and the memory may or may not be zeroed out. Therefore, it's risky to assume that the free memory points to zeroed-out memory.

# Storage:

The `MathMasters library` does not utilize contract storage. It consists entirely of pure functions and does not modify or read from storage. Therefore, issues related to incorrect storage slot packaging do not apply to this library.

Since the library only contains pure functions, it mainly deals with computations and does not interact with external contracts or read/write from/to storage. As a result, concerns related to storage efficiency and storage slot packaging are not applicable in this context. The main considerations for this library would be ensuring the correctness and efficiency of the mathematical operations it performs.