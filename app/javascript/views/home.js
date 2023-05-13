const apiKey = document.getElementById("trickAPIKEY");
apiKey.addEventListener("click", (event) => {
  navigator.clipboard.writeText(event.target.innerText).then(
    () => {
      alert("This api key copied!");
    },
    () => {
      alert("Failed to copy api key...");
    }
  );
});
