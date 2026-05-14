enum GraphRange {
  sixMonths("6 måneder", 6),
  oneYear("1 år", 12);

  const GraphRange(this.label, this.months);

  final String label;
  final int months;
}