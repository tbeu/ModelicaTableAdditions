#include "../C-Sources/ModelicaTableAdditions.h"
#include "Constants.h"
#include <array>
#include <gtest/gtest.h>

static double tab[4] = { 0.0, 1.0, 1.0, 2.0 };

extern "C"
{

int usertabadditions(char* tableName, int nipo, int dim[], int* colWise, double** table) {
    *table = tab;
    *colWise = 0;
    dim[0] = 2;
    dim[1] = 2;
    return 0; /* OK */
}

}

namespace
{

TEST(CombiTimeTable, Usertab_Linear_2x2) {
    double dummy = 0.0;
    constexpr const auto cols = std::array<int, 1>{2};
    void *table = ModelicaTableAdditions_CombiTimeTable_init2(
        no_name, "abc", &dummy, 0, 0, 0.0, const_cast<int*>(cols.data()), cols.size(),
        smooth_linear, extrapol_periodic, 0.0, time_events_always, verbose_off);
    EXPECT_TRUE(table != nullptr);
    const auto tmin = ModelicaTableAdditions_CombiTimeTable_minimumTime(table);
    EXPECT_NEAR(tmin, 0.0, 1e-10);
    const auto tmax = ModelicaTableAdditions_CombiTimeTable_maximumTime(table);
    EXPECT_NEAR(tmax, 1.0, 1e-10);
    const auto te = ModelicaTableAdditions_CombiTimeTable_nextTimeEvent(table, 1.5);
    const auto y = ModelicaTableAdditions_CombiTimeTable_getValue(table, 1, 1.5, te, te);
    EXPECT_NEAR(y, (1.0 + 2.0)/2, 1e-10);
    ModelicaTableAdditions_CombiTimeTable_close(table);
}

TEST(CombiTable2D, Bilinear_5x5_Symmetric) {
    constexpr const size_t nRows = 5;
    constexpr const size_t nCols = 5;
    double data[nRows*nCols] = {
        0.0, 0.0, 1.0, 2.0, 3.0,
        0.0, 1.0, 1.1, 1.2, 1.3,
        1.0, 1.1, 1.2, 1.3, 1.4,
        2.0, 1.2, 1.3, 1.4, 1.5,
        3.0, 1.3, 1.4, 1.5, 1.6
    };
    auto table = ModelicaTableAdditions_CombiTable2D_init2(
        no_name, no_name, data, nRows, nCols, smooth_linear, extrapol_error, verbose_off);
    EXPECT_TRUE(table != nullptr);
    const double u[] = { 0.0, 0.5, 1.0, 1.5, 2.5, 3.0 };
    const double y_expected[] = { 1.0, 1.1, 1.2, 1.3, 1.5, 1.6 };
    for (size_t i = 0; i < 3; ++i) {
        const auto y = ModelicaTableAdditions_CombiTable2D_getValue(table, u[i], u[i]);
        EXPECT_NEAR(y, y_expected[i], 1e-10);
    }
    ModelicaTableAdditions_CombiTable2D_close(table);
}

TEST(CombiTable2D, Bilinear_5x5) {
    constexpr const size_t nRows = 5;
    constexpr const size_t nCols = 5;
    double data[nRows*nCols] ={
        0.0, 0.0, 1.0, 2.0, 3.0,
        0.0, 1.0, 1.1, 1.2, 1.4,
        1.0, 1.3, 1.4, 1.5, 1.7,
        2.0, 1.5, 1.6, 1.7, 1.9,
        3.0, 1.6, 1.9, 2.2, 2.3
    };
    auto table = ModelicaTableAdditions_CombiTable2D_init2(
        no_name, no_name, data, nRows, nCols, smooth_linear, extrapol_error, verbose_off);
    EXPECT_TRUE(table != nullptr);
    const double u1[] = { 0.0, 0.5, 1.0, 1.5, 2.5, 3.0, 0.265371, 2.13849, 1.621140, 1.22198, 0.724681, 0.0596087 };
    const double u2[] = { 0.0, 0.5, 1.0, 1.5, 2.5, 3.0, 1.395400, 1.64760, 0.824957, 2.41108, 2.986190, 1.3648500 };
    const double y_expected[] = {
        1.0, 1.2, 1.4, 1.55, 2.025, 2.3, 1.2191513, 1.7242442248, 1.5067237, 1.626612, 1.6146423, 1.15436761 };
    for (size_t i = 0; i < 12; ++i) {
        const auto y = ModelicaTableAdditions_CombiTable2D_getValue(table, u1[i], u2[i]);
        EXPECT_NEAR(y, y_expected[i], 1e-10);
    }
    ModelicaTableAdditions_CombiTable2D_close(table);
}

TEST(CombiTable2D, Bicubic_5x5_Symmetric) {
    constexpr const size_t nRows = 5;
    constexpr const size_t nCols = 5;
    double data[nRows*nCols] = {
        0.0, 0.0, 1.0, 2.0, 3.0,
        0.0, 1.0, 1.1, 1.2, 1.3,
        1.0, 1.1, 1.2, 1.3, 1.4,
        2.0, 1.2, 1.3, 1.4, 1.5,
        3.0, 1.3, 1.4, 1.5, 1.6
    };
    auto table = ModelicaTableAdditions_CombiTable2D_init2(
        no_name, no_name, data, nRows, nCols, smooth_cubic, extrapol_error, verbose_off);
    EXPECT_TRUE(table != nullptr);
    const double u[] = { 1.0, 1.5, 2.0 };
    const double y_expected[] = { 1.2, 1.3, 1.4 };
    for (size_t i = 0; i < 3; ++i) {
        const auto y = ModelicaTableAdditions_CombiTable2D_getValue(table, u[i], u[i]);
        EXPECT_NEAR(y, y_expected[i], 1e-10);
    }
    ModelicaTableAdditions_CombiTable2D_close(table);
}

TEST(CombiTable2D, Bicubic_9x9_Symmetric) {
    constexpr const size_t nRows = 9;
    constexpr const size_t nCols = 9;
    double data[nRows*nCols] = {
        0,  1,  2,  3,  4,  5,  6,  7,  8,
        1,  1,  2,  3,  4,  5,  6,  7,  8,
        2,  2,  2,  6,  4, 10,  6, 14,  8,
        3,  3,  6,  3, 12, 15,  6, 21, 24,
        4,  4,  4, 12,  4, 20, 12, 28,  8,
        5,  5, 10, 15, 20,  5, 30, 35, 40,
        6,  6,  6,  6, 12, 30,  6, 42, 24,
        7,  7, 14, 21, 28, 35, 42,  7, 56,
        8,  8,  8, 24,  8, 40, 24, 56,  8
    };
    auto table = ModelicaTableAdditions_CombiTable2D_init2(
        no_name, no_name, data, nRows, nCols, smooth_cubic, extrapol_error, verbose_off);
    EXPECT_TRUE(table != nullptr);
    const double u1[] = { 1.4, 2.3, 4.7, 3.3, 7.5, 6.6, 5.1 };
    const double u2[] = { 1.0, 1.8, 1.9, 2.5, 2.7, 4.1, 3.3 };
    const double y_expected[] = {
        1.4, 3.11183531264736, 8.27114315792559, 5.03218982537718, 22.13230634702637,
        23.63206834997871, 17.28553080971182 };
    for (size_t i = 0; i < 7; ++i) {
        const auto y = ModelicaTableAdditions_CombiTable2D_getValue(table, u1[i], u2[i]);
        EXPECT_NEAR(y, y_expected[i], 1e-10);
        const auto yt = ModelicaTableAdditions_CombiTable2D_getValue(table, u2[i], u1[i]);
        EXPECT_NEAR(yt, y_expected[i], 1e-10);
    }
    ModelicaTableAdditions_CombiTable2D_close(table);
}

TEST(CombiTable2D, Bicubic_9x11_Original) {
    constexpr const size_t nRows = 9;
    constexpr const size_t nCols = 11;
    double data[nRows*nCols] = {
        0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
        1,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
        4,  2,  2,  6,  4, 10,  6, 14,  8, 11, 12,
        6,  3,  6,  3, 12, 15,  6, 21, 24, 13, 14,
        8,  4,  4, 12,  4, 20, 12, 28,  8, 15, 16,
        10, 5, 10, 15, 20,  5, 30, 35, 40, 17, 18,
        12, 6,  6,  6, 12, 30,  6, 42, 24, 19, 20,
        14, 7, 14, 21, 28, 35, 42,  7, 56, 21, 22,
        16, 8,  8, 24,  8, 40, 24, 56,  8, 23, 24
    };
    auto table = ModelicaTableAdditions_CombiTable2D_init2(
        no_name, no_name, data, nRows, nCols, smooth_cubic, extrapol_error, verbose_off);
    EXPECT_TRUE(table != nullptr);
    const double u1[] = { 1.0, 1.8, 1.9, 2.5, 2.7, 4.1, 3.3 };
    const double u2[] = { 1.4, 2.3, 9.7, 3.3, 9.5, 6.6, 5.1 };
    const double y_expected[] = {
        1.4, 2.46782030941187003, 10.7717721621846465, 4.80725067958096375,
        11.6747032398627297, 11.2619968682970111, 9.00168877916872567 };
    for (size_t i = 0; i < 7; ++i) {
        const auto y = ModelicaTableAdditions_CombiTable2D_getValue(table, u1[i], u2[i]);
        EXPECT_NEAR(y, y_expected[i], 1e-10);
    }
    ModelicaTableAdditions_CombiTable2D_close(table);
}

TEST(CombiTable2D, Bicubic_9x11_Transposed) {
    constexpr const size_t nRows = 11;
    constexpr const size_t nCols = 9;
    double data[nRows*nCols] = {
        0,  1,   4,  6,  8, 10, 12, 14, 16,
        1,  1,   2,  3,  4,  5,  6,  7,  8,
        2,  2,   2,  6,  4, 10,  6, 14,  8,
        3,  3,   6,  3, 12, 15,  6, 21, 24,
        4,  4,   4, 12,  4, 20, 12, 28,  8,
        5,  5,  10, 15, 20,  5, 30, 35, 40,
        6,  6,   6,  6, 12, 30,  6, 42, 24,
        7,  7,  14, 21, 28, 35, 42,  7, 56,
        8,  8,   8, 24,  8, 40, 24, 56,  8,
        9,  9,  11, 13, 15, 17, 19, 21, 23,
        10, 10, 12, 14, 16, 18, 20, 22, 24
    };
    auto table = ModelicaTableAdditions_CombiTable2D_init2(
        no_name, no_name, data, nRows, nCols, smooth_cubic, extrapol_error, verbose_off);
    EXPECT_TRUE(table != nullptr);
    const double u1[] = { 1.4, 2.3, 9.7, 3.3, 9.5, 6.6, 5.1 };
    const double u2[] = { 1.0, 1.8, 1.9, 2.5, 2.7, 4.1, 3.3 };
    const double y_expected[] = {
        1.4, 2.46782030941187003, 10.7717721621846465, 4.80725067958096375,
        11.6747032398627297, 11.2619968682970111, 9.00168877916872567 };
    for (size_t i = 0; i < 7; ++i) {
        const auto y = ModelicaTableAdditions_CombiTable2D_getValue(table, u1[i], u2[i]);
        EXPECT_NEAR(y, y_expected[i], 1e-10);
    }
    ModelicaTableAdditions_CombiTable2D_close(table);
}

}  // namespace

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
