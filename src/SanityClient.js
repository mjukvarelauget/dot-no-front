export const projectId = "ll3wkgw3";
export const dataset = "production";

export const SanityClient = require("@sanity/client")({
  projectId: projectId,
  dataset: dataset,
  useCdn: true,
});
