#include "../C-Sources/ModelicaTableAdditions.h"
#include "Constants.h"
#include <array>
#include <gtest/gtest.h>

namespace
{

TEST(CombiTable1D, Steffen_47x2) {
    double dummy = 0.0;
    constexpr const auto cols = std::array<int, 1>{2};
    auto table = ModelicaTableAdditions_CombiTable1D_init2(
        "../Data/Tables/test.mat", "tab1", &dummy, 0, 0, cols.data(), cols.size(),
        smooth_steffen, extrapol_error, verbose_on);
    const auto umin = ModelicaTableAdditions_CombiTable1D_minimumAbscissa(table);
    EXPECT_NEAR(umin, 0.0, 1e-10);
    const auto umax = ModelicaTableAdditions_CombiTable1D_maximumAbscissa(table);
    EXPECT_NEAR(umax, 46.0, 1e-10);
    const auto y = ModelicaTableAdditions_CombiTable1D_getValue(table, 1, 23.5);
    EXPECT_NEAR(y, 0.86, 1e-10);
    ModelicaTableAdditions_CombiTable1D_close(table);
}

}  // namespace

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
