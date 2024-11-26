const unsigned int interval = 1000;
static const char unknown_str[] = "n/a";
#define MAXLEN 2048

static const struct arg args[] = {
  { cpu_perc, "^fg(D3C6AA)%s%% ", NULL},
  { ram_perc, "^fg(a7C080)%s%% ", NULL},
  { battery_state, "^fg(D3C6AA)%s ", "BAT0"},
  { battery_perc, "^fg(D3C6AA)%s%% ", "BAT0"},
};
