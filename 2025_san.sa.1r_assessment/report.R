## Prepare plots and tables for report

## Before:
## After:

library(icesTAF)
taf.library(smsR)

mkdir("report")

df.tmb <- readRDS("data/df.tmb.rds")
Bpa <- readRDS("data/Bpa.rds")

sas <- readRDS("model/sas.rds")
mr <- readRDS("model/mr.rds")

F0 <- getF(df.tmb, sas)


mr$p1()
ggplot2::ggsave("report/mohns_rho.png")


plot(sas, Blim = df.tmb$betaSR, Bpa = Bpa)
ggplot2::ggsave("report/summary.png")


df.tmb$Bpa <- Bpa

df.out <- list(df.tmb = df.tmb, sas = sas, mr = mr)
pdiag <- plotDiagnostics(df.tmb, sas)

print(pdiag$survey)
ggplot2::ggsave("report/survey.png")

print(pdiag$sresids_scaled)
ggplot2::ggsave("report/survey_residuals_scaled.png")

print(pdiag$cresids_scaled)
ggplot2::ggsave("report/catch_residuals_scaled.png")

print(pdiag$cresids)
ggplot2::ggsave("report/survey_residuals.png")

# FCAP 2025
Fcap <- 0.33

df.tmb$M[, df.tmb$nyears + 1, ] <- df.tmb$M[, df.tmb$nyears, ]
df.tmb$Mat[, df.tmb$nyears + 1, ] <- df.tmb$Mat[, df.tmb$nyears, ]

xout <- getForecastTable(df.tmb, sas,
  TACold = 120428, Btarget = 140824, Flimit = Fcap, TACtarget = 5000,
  avg_R = df.tmb$years[1:(df.tmb$nyears - 1)]
)

saveRDS(xout, "report/xout.rds")
