let navigationItemViewFactory = combine(
  optional(RootView.init(state:)),
  optional(StepView.init(state:))
)
