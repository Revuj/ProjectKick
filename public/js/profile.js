const taskChart = document.getElementById('doughnut-chart-task');

const task = new Chart(taskChart, {
  type: 'doughnut',
  data: {
    labels: ['Completed', 'Today', 'Upcoming'],
    datasets: [
      {
        backgroundColor: ['#3e95cd', '#8e5ea2', '#3cba9f'],
        data: [taskChart.dataset.completedIssues, 0, taskChart.dataset.assignedIssues]
      }
    ]
  },
  options: {
    responsive: true,
    plugins: {
      doughnutlabel: {
        labels: [
          {
            text: 'Tasks',
            font: {
              size: '60'
            }
          },
          {
            text: parseInt(taskChart.dataset.completedIssues) + parseInt(taskChart.dataset.assignedIssues),
            font: {
              size: '50'
            }
          }
        ]
      }
    },
    font: function (context) {
      var width = context.chart.width;
      var size = Math.round(width / 32);
      return {
        size: size,
        weight: 600
      };
    },
    legend: {
      display: false
    }
  }
});

const projectsChart = document.getElementById('doughnut-chart-project');
const projectsData = new Chart(projectsChart, {
  type: 'doughnut',
  data: {
    labels: ['Finished', 'Active'],
    datasets: [
      {
        backgroundColor: ['#3e95cd', '#8e5ea2'],
        data: [projectsChart.dataset.closedProjects, projectsChart.dataset.openProjects]
      }
    ]
  },
  options: {
    responsive: true,
    plugins: {
      doughnutlabel: {
        labels: [
          {
            text: 'Projects',
            font: {
              size: '60'
            }
          },
          {
            text: parseInt(projectsChart.dataset.closedProjects) + parseInt(projectsChart.dataset.openProjects),
            font: {
              size: '50'
            }
          }
        ]
      }
    },
    font: function (context) {
      var width = context.chart.width;
      var size = Math.round(width / 32);
      return {
        size: size,
        weight: 600
      };
    },
    legend: {
      display: false
    }
  }
});

const projects = document.getElementsByClassName('project');
[...projects].forEach(elem => elem.addEventListener('click', event => {
  console.log(elem);
  window.location.href = `/projects/${elem.id}`;
}))

const edit_button = document.querySelector('.edit-button');
const cancel_buttons = document.querySelectorAll('.cancel');
const update_button = document.querySelector('#update');
const close_button = document.querySelector('#close-edit');
const edit_container = document.getElementById('edit');
const details_container = document.getElementById('details');
const user_card = document.querySelector('#user');

[...cancel_buttons, edit_button, update_button, close_button].forEach(elem =>
  elem.addEventListener('click', toggleEditSection
  ));

function toggleEditSection(event) {
  event.preventDefault();
  edit_container.classList.toggle('d-none');
  details_container.classList.toggle('d-none');
}

const deleteButton = document.getElementById("delete");
deleteButton.addEventListener('click', deleteUser);

function deleteHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response);
  window.location.replace("/");
}

function deleteUser(e) {
  e.preventDefault();
  console.log(deleteButton);
  let id = deleteButton.dataset.user;
  console.log(id);
  sendAjaxRequest("delete", `../api/users/${id}`, {}, deleteHandler);
}

const updateButton = document.getElementById("update");
updateButton.addEventListener('click', updateUser);

function updateUserHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response);
  document.getElementById("username").innerHTML = response.username;
  document.getElementById("email").innerHTML = response.email;
  document.getElementById("phone_number").innerHTML = response.phone_number;
  document.getElementById("description").innerHTML = response.description;
}

function updateUser(e) {
  e.preventDefault();
  console.log(updateButton);
  let id = deleteButton.dataset.user;
  let username = document.getElementById("feUsername").value;
  let firstName = document.getElementById("feFirstName").value;
  let lastName = document.getElementById("feLastName").value;
  let email = document.getElementById("feEmail").value;
  let phone = document.getElementById("fePhone").value;
  let password = document.getElementById("fePassword").value;
  let confirmPassword = document.getElementById("feConfirmPassword").value;
  let city = document.getElementById("feCity").value;
  let description = document.getElementById("feDescription").value;

  console.log({ username, firstName, lastName, email, phone, password, confirmPassword, city, description });
  sendAjaxRequest("post", `../api/users/${id}`, { username, firstName, lastName, email, phone, password, confirmPassword, city, description }, updateUserHandler);
}


function updatePhotoHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response);
}

let uploadForm = document.querySelector(".edit-photo");
let fileInput = document.getElementById("upload-photo");

fileInput.addEventListener('change', uploadPhoto);
console.log(fileInput);

function uploadPhoto() {

}