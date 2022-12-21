// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

// Modules to add on your own
import { getXhr, postXhr } from "./ajax";

const homeAddRequestButton = document.getElementById("homeAddRequest");
homeAddRequestButton.addEventListener("click", () => {
  postXhr(
    "/home/add",
    {
      user_id: 1,
      from: "127.0.0.1",
      header: { text: "text" },
      body: { body: "body" },
    },
    () => {
      window.location.reload();
    }
  );
});
