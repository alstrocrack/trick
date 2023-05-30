const copyBtn = document.getElementById("trickAPIKEYCopy");
const apiKey = document.getElementById("trickAPIKEY");

if (apiKey && copyBtn) {
  copyBtn.addEventListener("click", () => {
    navigator.clipboard.writeText(apiKey.textContent).then(
      () => {
        copyBtn.textContent = "copied!";
      },
      () => {
        alert("Failed to copy api key...");
      }
    );
  });
}
