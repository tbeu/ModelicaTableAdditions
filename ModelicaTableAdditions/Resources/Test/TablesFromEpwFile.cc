#include "../C-Sources/ModelicaTableAdditions.h"
#include "Constants.h"
#include <array>
#include <gtest/gtest.h>

namespace
{

TEST(CombiTable1D, Makima_8760x30) {
    double dummy = 0.0;
    constexpr const auto cols = std::array<int, 1>{5};
    auto table = ModelicaTableAdditions_CombiTable1D_init2(
        "../Data/Weather/weather.epw", "data", &dummy, 0, 0, cols.data(), cols.size(),
        smooth_makima, extrapol_error, verbose_on);
    const auto umin = ModelicaTableAdditions_CombiTable1D_minimumAbscissa(table);
    EXPECT_NEAR(umin, 0.0, 1e-10);
    const auto umax = ModelicaTableAdditions_CombiTable1D_maximumAbscissa(table);
    EXPECT_NEAR(umax, (8760 - 1) * 3600, 1e-10);
    const auto y1 = ModelicaTableAdditions_CombiTable1D_getValue(table, 1, umin);
    EXPECT_NEAR(y1, 98213, 1e-10);
    const auto y2 = ModelicaTableAdditions_CombiTable1D_getValue(table, 1, umax);
    EXPECT_NEAR(y2, 97278, 1e-10);
    ModelicaTableAdditions_CombiTable1D_close(table);
}

}  // namespace

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
