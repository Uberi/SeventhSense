#include <stdio.h>
#include <assert.h>

// this is a quick program used for making sure `get_direction` behaves in a sane way
// I compiled this with Clang/LLVM, but it should work fine anywhere that math is supported

#define MAGNETOMETER_OVERFLOW (-4096)
#define TRIG_SCALE (long)10000
#define TAN_22_5 (long)4142 // TRIG_SCALE * tan(22.5 deg)
#define NORTH 1
#define NORTHEAST 2
#define EAST 3
#define SOUTHEAST 4
#define SOUTH 5
#define SOUTHWEST 6
#define WEST 7
#define NORTHWEST 8
#define NO_DIRECTION 0

static long axis_x, axis_y;
char get_direction(int x, int y, int z) {
    // handle overflow values
    if (x == MAGNETOMETER_OVERFLOW
     || y == MAGNETOMETER_OVERFLOW
     || z == MAGNETOMETER_OVERFLOW)
        return NO_DIRECTION; // unknown index

    axis_x = (long)x;
    axis_y = (long)y;
    
    // handle edge cases
    if (axis_x == 0 && axis_y == 0) // no angle
        return NO_DIRECTION;
    if (axis_x == 0)
        return y < 0 ? SOUTH : NORTH;
    if (axis_y == 0)
        return x < 0 ? WEST : EAST;

    // handle the cases in between the extremes
    if (axis_x > 0 && axis_y > 0) { // first quadrant
        if (axis_y * TRIG_SCALE < axis_x * TAN_22_5) // angle less than 22.5 degrees
            return EAST;
        if (axis_x * TRIG_SCALE < axis_y * TAN_22_5) // angle more than 90 - 22.5 degrees
            return NORTH;
        return NORTHEAST;
    }
    if (axis_x < 0 && axis_y > 0) { // second quadrant
        if (axis_y * TRIG_SCALE < -axis_x * TAN_22_5) // angle less than 90 + 22.5 degrees
            return WEST;
        if (-axis_x * TRIG_SCALE < axis_y * TAN_22_5) // angle more than 180 - 22.5 degrees
            return NORTH;
        return NORTHWEST;
    }
    if (axis_x < 0 && axis_y < 0) { // third quadrant
        if (-axis_y * TRIG_SCALE < -axis_x * TAN_22_5) // angle less than 180 + 22.5 degrees
            return WEST;
        if (-axis_x * TRIG_SCALE < -axis_y * TAN_22_5) // angle more than 270 - 22.5 degrees
            return SOUTH;
        return SOUTHWEST;
    }
    // fourth quadrant
    if (-axis_y * TRIG_SCALE < axis_x * TAN_22_5) // angle less than 270 + 22.5 degrees
        return EAST;
    if (axis_x * TRIG_SCALE < -axis_y * TAN_22_5) // angle more than 360 - 22.5 degrees
        return SOUTH;
    return SOUTHEAST;
}

#define TEST(x) if(!(x)) printf("Test " #x " failed!\n");

int main(void) {
    TEST(0 == get_direction(0, 0, 0));
    TEST(1 == get_direction(-1, 500, 0));
    TEST(1 == get_direction(0, 500, 0));
    TEST(1 == get_direction(1, 500, 0));
    TEST(1 == get_direction(380, 924, 0));
    TEST(2 == get_direction(390, 924, 0));
    TEST(2 == get_direction(250, 250, 0));
    TEST(2 == get_direction(924, 390, 0));
    TEST(3 == get_direction(924, 380, 0));
    TEST(3 == get_direction(500, 1, 0));
    TEST(3 == get_direction(500, 0, 0));
    TEST(3 == get_direction(500, -1, 0));
    TEST(3 == get_direction(924, -380, 0));
    TEST(4 == get_direction(924, -390, 0));
    TEST(4 == get_direction(250, -250, 0));
    TEST(4 == get_direction(390, -924, 0));
    TEST(5 == get_direction(380, -924, 0));
    TEST(5 == get_direction(-1, -500, 0));
    TEST(5 == get_direction(0, -500, 0));
    TEST(5 == get_direction(1, -500, 0));
    TEST(5 == get_direction(-380, -924, 0));
    TEST(6 == get_direction(-924, -390, 0));
    TEST(6 == get_direction(-250, -250, 0));
    TEST(6 == get_direction(-390, -924, 0));
    TEST(7 == get_direction(-924, 380, 0));
    TEST(7 == get_direction(-500, 1, 0));
    TEST(7 == get_direction(-500, 0, 0));
    TEST(7 == get_direction(-500, -1, 0));
    TEST(7 == get_direction(-924, 380, 0));
    TEST(8 == get_direction(-390, 924, 0));
    TEST(8 == get_direction(-250, 250, 0));
    TEST(8 == get_direction(-924, 390, 0));
    printf("All tests passed!\n");
}
