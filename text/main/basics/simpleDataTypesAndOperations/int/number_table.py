"""Create a LaTeX table with numbers in different systems."""
from math import ceil, log

COLUMNS = 2
MAX_NUMBER = COLUMNS * ceil((64 + 1) / COLUMNS)

BASES = {"dec": 10, "bin": 2, "oct": 8, "hex": 16}
HIGHLIGHTS = ["red", "blue", "violet", "green!80!black"]

BASE_NAMES_LIST = ["decimal~(dec)", "binary~(bin)", "octal~(oct)",
                   "hexadecimal~(hex)"]
DIGITS = [hex(i)[-1] for i in range(max(BASES.values()))]

print(r"\begin{table}%")
print(r"\centering%")
print(r"\setlength{\tabcolsep}{0.2em}%")

base_names = ", ".join(BASE_NAMES_LIST[:-1]) + ", and " + BASE_NAMES_LIST[-1]
print(
    r"\caption{A table with number conversions to the "
    + base_names.lower() +
    " systems. The values of the digits are noted in the second row of "
    "the header. Powers of the bases are highlighted.}%")
print(r"\label{tbl:numbersBases}%")
print(r"\smallskip%")
print(r"\resizebox{0.99999\linewidth}{!}{")

BASE_COLS = [int(ceil(log(MAX_NUMBER + 1, base))) for base in BASES.values()]
COL_WIDTHS = [f"{ceil(log(base ** (BASE_COLS[i] - 1) + 1, 10))}ex"
              for i, base in enumerate(BASES.values())]

BASE_HEADER_1_lst = [r"\textbf{" + name + "}" for name in BASES]
BASE_HEADER_1 = "&".join((r"\multicolumn{" + str(bc) + r"}{c" + (
    "|" if i < len(BASE_COLS) - 1 else "ZZ") + "}{"
    + BASE_HEADER_1_lst[i] + "}") for i, bc in enumerate(BASE_COLS))

BASE_HEADER_2_lst = ["Base~" + str(base) for base in BASES.values()]
BASE_HEADER_2 = "&".join((r"\multicolumn{" + str(bc) + r"}{c" + (
    "|" if i < len(BASE_COLS) - 1 else "ZZ") + "}{"
    + BASE_HEADER_2_lst[i] + "}") for i, bc in enumerate(BASE_COLS))
BASE_HEADER_3 = "&".join(
    (r"\parbox{" + COL_WIDTHS[i] + r"}{\centering\noindent" +
    str(base ** (BASE_COLS[i] - j - 1)) + "}") for i, base in enumerate(
    BASES.values()) for j in range(BASE_COLS[i]))
BASE_COLS_STRS = "|".join(( ("c" * j) for i, j in enumerate(BASE_COLS)))

print(r"\begin{tabular}{" + "||".join(BASE_COLS_STRS
                                      for _ in range(COLUMNS)) + "}%")
print(r"\hline%")
print(("&".join(BASE_HEADER_1 for _ in range(COLUMNS)) + r"\\%").replace(
    "ZZ", "||", COLUMNS-1).replace("ZZ", ""))
#print(("&".join(BASE_HEADER_2 for _ in range(COLUMNS)) + r"\\%").replace(
#    "ZZ", "||", COLUMNS-1).replace("ZZ", ""))
print("&".join(BASE_HEADER_3 for _ in range(COLUMNS)) + r"\\%")
print(r"\hline%")

output = ""
color_row = False
for number in range(MAX_NUMBER):

    for i, base in enumerate(BASES.values()):
        use_num = number
        if use_num > 0:
            pw_check = log(use_num, base)
            highlight = pw_check == int(pw_check)
        else:
            highlight = False
        if highlight:
            hls = r"\textcolor{" + HIGHLIGHTS[i] + r"}{\textbf{"
            hle = r"}}"
        else:
            hls = hle = ""
        for j in range(BASE_COLS[i]):
            value = base ** (BASE_COLS[i] - j - 1)
            res = use_num // value

            output = output + hls + DIGITS[res] + hle + "&"
            use_num = use_num % value

    if (number + 1) % COLUMNS == 0:
        output = output[:-1] + r"\\%"
        if color_row:
            output = r"\rowcolor{gray!20}" + output
        color_row = not color_row
        print(output)
        output = ""
        continue

print(r"\hline%")
print(r"\end{tabular}%")
print("}%")
print(r"\end{table}%")
