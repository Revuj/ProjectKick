let sideIssue = document.querySelector("#side-issue");
let sideIssueButtons = document.querySelectorAll(".issue");
let pageWrapper = document.querySelector(".page-wrapper");
let side_issue_header = document.querySelector("#side-issue-header");
let title = side_issue_header.querySelector(".task-title");
let editTitleFrom = side_issue_header.querySelector(".edit-issue-title-form");
let cancelEditTitleButton = side_issue_header.querySelector(
  ".edit-item-title-cancel"
);
let closeSideIssueButton = document.querySelector(".close-side-issue");

function mouseOverListItem(elem) {
  elem.addEventListener("mouseover", event => {
    elem.querySelector(".edit-task").classList.remove("d-none");
  });
}

function mouseLeaveListItem(elem) {
  elem.addEventListener("mouseleave", event => {
    elem.querySelector(".edit-task").classList.add("d-none");
  });
}

mouseOverListItem(side_issue_header);
mouseLeaveListItem(side_issue_header);

side_issue_header
  .querySelector(".edit-task")
  .addEventListener("click", event => {
    editTitleFrom.querySelector("input").value = title.innerHTML;
    title.classList.toggle("d-none");
    editTitleFrom.classList.toggle("d-none");
    side_issue_header.querySelector("p").classList.toggle("d-none");
  });

closeSideIssueButton.addEventListener("click", event => {
  pageWrapper.classList.toggle("is-collapsed-right");
  title.classList.toggle("d-none");
  editTitleFrom.classList.toggle("d-none");
  side_issue_header.querySelector("p").classList.toggle("d-none");
});

cancelEditTitleButton.addEventListener("click", event => {
  title.classList.toggle("d-none");
  editTitleFrom.classList.toggle("d-none");
  side_issue_header.querySelector("p").classList.toggle("d-none");
});

[...sideIssueButtons].forEach(elem =>
  elem.addEventListener("click", function() {
    let taskID = elem.getAttribute("id");
    console.log(elem);
    let taskTitle = elem.querySelector(".task-title").innerHTML;
    if (pageWrapper.classList.contains("is-collapsed-right")) {
      title.classList.remove("d-none");
      editTitleFrom.classList.add("d-none");
      side_issue_header.querySelector("p").classList.remove("d-none");
      if (taskID !== sideIssue.getAttribute("data-task-id")) {
        sideIssue.setAttribute("data-task-id", taskID);
        sideIssue.querySelector(".task-title").innerHTML = taskTitle;
      } else {
        pageWrapper.classList.toggle("is-collapsed-right");
      }
    } else {
      sideIssue.setAttribute("data-task-id", taskID);
      sideIssue.querySelector(".task-title").innerHTML = taskTitle;

      pageWrapper.classList.toggle("is-collapsed-right");
    }
  })
);
