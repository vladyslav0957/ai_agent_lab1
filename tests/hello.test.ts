import { describe, expect, it } from "vitest";
import { add } from "../src/hello";

describe("BasicAddition", () => {
  it("adds two numbers", () => {
    expect(add(2, 2)).toBe(4);
  });
});
