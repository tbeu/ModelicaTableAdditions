#include "../C-Sources/ModelicaTableAdditions.h"
#include "Constants.h"
#include <array>
#include <gtest/gtest.h>

namespace
{

TEST(CombiTable1D, Linear_47x2) {
    double dummy = 0.0;
    constexpr const auto cols = std::array<int, 1>{2};
    auto table = ModelicaTableAdditions_CombiTable1D_init3(
        "../Data/Tables/test.csv", "dummy", &dummy, 0, 0, const_cast<int*>(cols.data()), cols.size(),
        smooth_linear, extrapol_error, verbose_on, delimiter_comma, 1);
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
