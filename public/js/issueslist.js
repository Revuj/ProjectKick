let sideIssue = document.querySelector("#side-issue");
let sideIssueButtons = document.querySelectorAll(".issue");
let pageWrapper = document.querySelector(".page-wrapper");
let side_issue_header = document.querySelector("#side-issue-header");
let delete_issue_button = document.querySelector("#delete-issue-button");
let title = side_issue_header.querySelector(".task-title");
let editTitleFrom = side_issue_header.querySelector(".edit-issue-title-form");
let cancelEditTitleButton = side_issue_header.querySelector(
  ".edit-item-title-cancel"
);
let closeSideIssueButton = document.querySelector(".close-side-issue");
let nav_links = document.querySelectorAll(".nav-links li");
let issue_list = document.querySelector("#issue-list");

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

[...sideIssueButtons].forEach(elem => openSideIssueListen(elem));

function openSideIssueListen(elem) {
  // elem.addEventListener("click", function () {
  //   console.log(elem);
  //   let taskID = elem.getAttribute("id");
  //   let taskTitle = elem.querySelector(".task-title").innerHTML;
  //   let authorName = elem.querySelector(".author-reference").innerHTML;
  //   let description = elem.querySelector(".issue-description").innerHTML;
  //   let dueDate = elem.querySelector(".issue-due-date").innerHTML;
  //   let assignees = elem.querySelectorAll(".assignee");
  //   let labels = elem.querySelectorAll(".list-item-label");
  //   if (pageWrapper.classList.contains("is-collapsed-right")) {
  //     title.classList.remove("d-none");
  //     editTitleFrom.classList.add("d-none");
  //     side_issue_header.querySelector("p").classList.remove("d-none");
  //     if (taskID !== sideIssue.getAttribute("data-task-id")) {
  //       sideIssue.setAttribute("data-task-id", taskID);
  //       sideIssue.querySelector(".task-title").innerHTML = taskTitle;
  //       sideIssue.querySelector("#issue-author").innerHTML = authorName;
  //       sideIssue.querySelector("#issue-description").innerHTML = description;
  //       sideIssue.querySelector("#due-date").innerHTML = dueDate;
  //     } else {
  //       pageWrapper.classList.toggle("is-collapsed-right");
  //     }
  //   } else {
  //     sideIssue.setAttribute("data-task-id", taskID);
  //     sideIssue.querySelector(".task-title").innerHTML = taskTitle;
  //     sideIssue.querySelector("#issue-author").innerHTML = authorName;
  //     sideIssue.querySelector("#issue-description").innerHTML = description;
  //     sideIssue.querySelector("#due-date").innerHTML = dueDate;
  //     pageWrapper.classList.toggle("is-collapsed-right");
  //   }
  //   delete_issue_button.dataset.issueId = taskID;

  //   let sideBarAssignees = document.querySelector("#side-issue .assignees");
  //   sideBarAssignees.innerHTML = "";
  //   assignees.forEach(elem => {
  //     sideBarAssignees.innerHTML += `
  //     <li class="mr-2">
  //       ${elem.innerHTML}
  //     </li>
  //     `;
  //   });
  //   sideBarAssignees.innerHTML += `
  //   <li>
  //     <button
  //       type="button"
  //       class="custom-button add-button add-assignee"
  //     >
  //       <i class="fas fa-plus"></i>
  //     </button>
  //   </li>`

  //   let sideBarLabels = document.querySelector(".labels");
  //   sideBarLabels.innerHTML = "";
  //   labels.forEach(elem => {
  //     sideBarLabels.innerHTML += `
  //     <li class="mr-2">
  //       <h6 class="mb-0 p-1 list-item-label bg-info">
  //         ${elem.innerHTML}
  //       </h6>
  //     </li>
  //     `;
  //   });
  //   sideBarLabels.innerHTML += `
  //   <li>
  //     <button
  //       type="button"
  //       class="custom-button add-button add-label"
  //     >
  //       <i class="fas fa-plus"></i>
  //     </button>
  //   </li>
  //   `
  // });
}

/* Delete Issue */
delete_issue_button.addEventListener("click", event => {
  let issue_id = delete_issue_button.getAttribute("data-issue-id");
  let url = `/api/issues/${issue_id}`;
  console.log({ issue_id })
  sendAjaxRequest("delete", url, { 'issue': issue_id }, deleteIssueHandler);
  pageWrapper.classList.toggle("is-collapsed-right");
});

function deleteIssueHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response);
  let issue_id = response['id'];
  let issue = document.getElementById(issue_id);
  issue.parentElement.removeChild(issue);
}

/************ some function that may be used in other files in the future *******************/
let current_date = new Date().toISOString().slice(0, 10);

let mappingMonths = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Au",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

function dateDifference(date) {
  const date1 = new Date(date);
  const date2 = new Date(current_date);
  const diffTime = Math.abs(date2 - date1);
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

  if (diffDays === 1) {
    return "Yesterday";
  } else if (diffDays < 7) {
    return diffDays + " days ago";
  } else if (diffDays < 30) {
    let weeks = Math.floor(diffDays / 7);
    return weeks.toString() + (weeks == 1 ? " week ago" : " weeks ago");
  } else if (diffDays < 365) {
    let months = Math.floor(diffDays / 30);
    return months.toString() + (months == 1 ? " month ago" : " months ago");
  } else {
    let years = Math.floor(diffDays / 365);
    console.log(years);
    return years.toString() + (years == 1 ? " year ago" : " years ago");
  }
}

function dateExtended(dateString) {
  let [year, month, day] = dateString.split("-");
  return mappingMonths[parseInt(day)] + " " + month + ", " + year;
}

/***************** filters, sorts *******************************/
let ascendent = true; /*page is loaded with sorted ascendent */
let sorting_type = null;
let issues_ul = document.querySelector("#issue-list");
let sortBy = document.querySelectorAll(
  "#filter-buttons .dropdown-menu .dropdown-item"
);

let issues = [
  {
    text: "boards",
    description: "Some description dope pope",
    due_date: "2021-03-11",
    creation_date: "2021-03-11",
    is_completed: "false",
    tags: [{ name: "Doing", color: "#12121211" }],
    authorship: "John",
    assignees: [
      {
        src: "https://avatars2.githubusercontent.com/u/44231794?s=40&v=4",
        name: "John"
      },
      {
        src: "https://avatars2.githubusercontent.com/u/44231794?s=40&v=4",
        name: "John"
      },
      {
        src: "https://avatars2.githubusercontent.com/u/44231794?s=40&v=4",
        name: "John"
      }
    ]
  },
  {
    text: "finish design",
    description: "the guy who knows, knows...",
    due_date: "2020-02-01",
    creation_date: "2021-03-11",
    is_completed: "true",
    tags: [{ name: "Doing", color: "#12121211" }],
    authorship: "John",
    assignees: [
      {
        src: "https://avatars2.githubusercontent.com/u/44231794?s=40&v=4",
        name: "John"
      },
      {
        src: "https://avatars2.githubusercontent.com/u/44231794?s=40&v=4",
        name: "John"
      }
    ]
  },
  {
    text: "normalize database",
    description: "royce gonna learn",
    due_date: "null",
    creation_date: "2021-03-11",
    is_completed: "true",
    tags: [{ name: "Doing", color: "#92191211" }],
    authorship: "John",
    assignees: []
  }
];

[...nav_links].forEach(elem => {
  elem.addEventListener("click", event => {
    nav_links.forEach(elem => {
      elem.classList.remove("active");
    });
    elem.classList.add("active");
    let issues = document.getElementsByClassName("issue");
    console.log(issues);
    switch (elem.id) {
      case "open-issues":
        [...issues].forEach(elem => { if (!elem.classList.contains("open")) elem.classList.add("d-none"); else elem.classList.remove("d-none") });
        break;
      case "closed-issues":
        [...issues].forEach(elem => { if (!elem.classList.contains("closed")) elem.classList.add("d-none"); else elem.classList.remove("d-none") });
        break;
      case "all-issues":
        [...issues].forEach(elem => elem.classList.remove("d-none"));
        break;
    }
  });
});

/*
to add new sorts just add new attributes to sort by
*/
sortBy.forEach(sort =>
  sort.addEventListener("click", e => {
    let type_of_sort = e.target.innerHTML.toLowerCase();
    sorting_type = type_of_sort;
    /*the issues should already be filtered here */

    sortingElementsHTML(type_of_sort);
  })
);

function sortingElementsHTML(type_of_sort) {
  let sort = ascendent ? "asc" : "desc";

  switch (type_of_sort) {
    case "due date":
      //issuesHTML(issues.sort(sortBySingleProperty("due_date", sort)));
      break;
    case "opening date":
      //
      break;
    case "assignees":
      console.log(issues.sort(sortByPropertyArray("assignees", sort)));
      break;
  }
}

/*null values always in the end */
function sortBySingleProperty(property, order = "asc") {
  let sort_order = 1;
  if (order === "desc") {
    sort_order = -1;
  }
  return function (a, b) {
    if (a[property] === "null") return 1;
    if (a[property] < b[property]) {
      return -1 * sort_order;
    } else if (a[property] > b[property]) {
      return 1 * sort_order;
    } else {
      return 0 * sort_order;
    }
  };
}
/*make it so the length of the array is the sort decision */
function sortByPropertyArray(property, order = "asc") {
  let sort_order = 1;
  if (order === "desc") {
    sort_order = -1;
  }
  return function (a, b) {
    if (a[property] === "null") return 1;
    if (a[property].length < b[property].length) {
      return -1 * sort_order;
    } else if (a[property].length > b[property].length) {
      return 1 * sort_order;
    } else {
      return 0 * sort_order;
    }
  };
}

function renderIssues(issues) {
  issues.forEach(issue => {
    issues_ul.innerHTML += issueoutputHTML(issue);
  });
}

function issueoutputHTML(issue) {
  let status = issue["is_completed"] === "true" ? "open" : "closed";

  let labels_output = '<ul class="labels d-flex justify-content-center mx-2">';
  let days_created = dateDifference(issue["creation_date"]);
  let due_days =
    issue["due_date"] === "null"
      ? ""
      : `<div class="due-date-container text-right">
    <i class="fas fa-calendar-alt mr-2"></i>${dateExtended(issue["due_date"])}
  </div>`;
  let assignees_output = "";

  issue["tags"].forEach(tag => {
    labels_output += `
      <li class="mr-2">
        <h6 style="background-color:${tag["color"]}" class="mb-0 px-1 list-item-label bg-success">${tag["name"]}</h6>
      </li>
    `;
  });
  labels_output += "</ul>";

  issue["assignees"].forEach(assignee => {
    assignees_output += `
    <li class="mr-2">
      <img
        src="${assignee["src"]}"
        alt="${assignee["name"]}"
        draggable="false"
      />
   </li>
    `;
  });

  console.log(labels_output);

  const output = `<li class="issue ${status} px-2 border-bottom">
      <div class="issue-header d-flex align-items-center">
        <a href="issue.html" class="task-title nostyle">${issue["text"]}</a>

        ${labels_output}

        ${due_days}

        <a href="issue.html" class="nostyle comments-number-container ml-auto">
          <i class="fas fa-comments mr-2"></i>2
        </a>
      </div>
      <div class="d-flex issue-status">
        <p>
          #8<span class="issue-status-description">
            Opened by <span class="author-reference">${issue["authorship"]}</span> ${days_created}</span>
        </p>

        <div class="assignees-container ml-auto text-center">
          <ul class="assignees d-flex ">
           ${assignees_output}
          </ul>
        </div>
      </div>
    </li>`;

  return output;
}

let project_id = document.getElementById("project-name").dataset.project;

document.getElementById("issues-filter-form").addEventListener("submit", (event) => {
  event.preventDefault();
  let search = document.getElementById("issues-filter").value;
  console.log(search);
  if (search.length > 0) {
    sendAjaxRequest("POST", `/api/${project_id}/issues`, { search }, searchIssue);
  } else {
    let issues = document.getElementsByClassName("issue");
    [...issues].forEach(elem => {
      elem.classList.remove("d-none");
    });
  }
})

function searchIssue() {
  const response = JSON.parse(this.responseText);
  console.log(response);

  let issues = document.getElementsByClassName("issue");
  [...issues].forEach(elem => {
    elem.classList.add("d-none");
  });

  for (elem in response) {
    let id = response[elem].id;
    document.getElementById(id).classList.remove("d-none");
  }

}
