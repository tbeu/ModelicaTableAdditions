#include "../C-Sources/ModelicaTableAdditions.h"
#include "Constants.h"
#include <array>
#include <gtest/gtest.h>

namespace
{

class CombiTable1DTest
    : public ::testing::TestWithParam<std::pair<const char *, const char *>> {
protected:
    void SetUp() override {}
    void TearDown() override {}
};

TEST_P(CombiTable1DTest, Steffen_47x2) {
    double dummy = 0.0;
    constexpr const auto cols = std::array<int, 1>{2};
    auto table = ModelicaTableAdditions_CombiTable1D_init2(
        std::get<0>(GetParam()), std::get<1>(GetParam()), &dummy, 0, 0,
        cols.data(), cols.size(), smooth_steffen, extrapol_error, verbose_on);
    const auto umin = ModelicaTableAdditions_CombiTable1D_minimumAbscissa(table);
    EXPECT_NEAR(umin, 0.0, 1e-10);
    const auto umax = ModelicaTableAdditions_CombiTable1D_maximumAbscissa(table);
    EXPECT_NEAR(umax, 46.0, 1e-10);
    const auto y = ModelicaTableAdditions_CombiTable1D_getValue(table, 1, 23.5);
    EXPECT_NEAR(y, 0.86, 1e-10);
    ModelicaTableAdditions_CombiTable1D_close(table);
}

INSTANTIATE_TEST_SUITE_P(
    TablesFromMatFile, CombiTable1DTest,
    ::testing::Values(
        std::make_pair("../Data/Tables/test_v4.mat", "tab1"),
        std::make_pair("../Data/Tables/test_v6.mat", "tab1"),
        std::make_pair("../Data/Tables/test_v7.mat", "tab1"))
);

} // namespace

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
