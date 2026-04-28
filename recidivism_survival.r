# 1. Load necessary libraries
# If you don't have them, run: install.packages(c("survival", "survminer"))
library(survival)
library(survminer)

# 2. Use the built-in 'mgus' dataset or create a forensic proxy
# For this project, we'll simulate a dataset based on common forensic metrics
set.seed(42)
n <- 200
forensic_data <- data.frame(
  id = 1:n,
  time_to_event = rweibull(n, shape=1, scale=50), # Days until re-offense
  status = sample(0:1, n, replace=TRUE),         # 1 = Recidivism, 0 = Censored
  treatment_group = sample(c("Therapy", "Control"), n, replace=TRUE),
  prior_offenses = rpois(n, lambda=2)
)

# 3. Create the Survival Object
surv_obj <- Surv(time = forensic_data$time_to_event, event = forensic_data$status)

# 4. Fit a Cox Regression Model
# This shows how treatment and priors affect the "Hazard" (risk) of crime
fit_cox <- coxph(surv_obj ~ treatment_group + prior_offenses, data = forensic_data)
summary(fit_cox)

# 5. Visualize the Kaplan-Meier Curves
km_fit <- survfit(surv_obj ~ treatment_group, data = forensic_data)
ggsurvplot(km_fit, 
           data = forensic_data, 
           risk.table = TRUE, 
           pval = TRUE, 
           conf.int = TRUE,
           title = "Recidivism Risk: Therapy vs. Control Group",
           xlab = "Days Post-Release",
           ylab = "Probability of Non-Recidivism")


# 1. Re-run the fit and the plot
p <- ggsurvplot(km_fit, 
           data = forensic_data, 
           risk.table = TRUE, 
           pval = TRUE, 
           conf.int = TRUE,
           palette = c("#E7B800", "#2E9FDF"), # Professional colors
           title = "Recidivism Risk: Therapy vs. Control Group",
           xlab = "Days Post-Release",
           ylab = "Probability of Non-Recidivism")

# 2. Explicitly print it to your screen to check
print(p)

# 3. Save it correctly (This is the important part)
# We use p$plot because p is a list containing the plot AND the risk table
ggsave("recidivism_plot_v2.png", plot = p$plot, width = 10, height = 7, dpi = 300)