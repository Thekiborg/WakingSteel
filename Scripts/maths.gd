extends Node

func normalize01(x: float, min_val: float, max_val: float):
	return (x - min_val) / (max_val - min_val)

func normalizeXY(x: float, y:float, t: float, min_val: float, max_val:float):
	return normalize01(t, min_val, max_val) * (y - x) + x
