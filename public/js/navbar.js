let user_dropdown = document.querySelector(".user-dropdown");
let notification_dropdown = document.querySelector(".notification-dropdown");

let notifcation = document.querySelector(".notification");
if (notifcation !== null) {
  notifcation.addEventListener("click", function () {
    notification_dropdown.classList.toggle("d-none");
    if (!user_dropdown.classList.contains("d-none"))
      user_dropdown.classList.add("d-none");
  });
}

document.querySelector(".user").addEventListener("click", function () {
  user_dropdown.classList.toggle("d-none");
  if (
    notification_dropdown !== null &&
    !notification_dropdown.classList.contains("d-none")
  )
    notification_dropdown.classList.add("d-none");
});
