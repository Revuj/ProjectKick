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
const edit_photo = document.querySelector('#edit-photo-button');

[...cancel_buttons, edit_button, close_button].forEach(elem =>
  elem.addEventListener('click', toggleEditSection
  ));

function toggleEditSection(event) {
  event.preventDefault();
  edit_container.classList.toggle('d-none');
  details_container.classList.toggle('d-none');
  edit_photo.classList.toggle('d-none');
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
  sendAjaxRequest("delete", `/api/users/${id}`, {}, deleteHandler);
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

  fetch(`/api/users/${id}`, {
    method: 'PUT',
    body: JSON.stringify({ username, firstName, lastName, email, phone, password, confirmPassword, city, description }),
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content'),
    }
  }).then((res) => {
    if (res.ok) {
      res.json().then(data => {
        document.getElementById("username").innerHTML = data.username;
        document.getElementById("email").innerHTML = data.email;
        document.getElementById("phone_number").innerHTML = data.phone_number;
        document.getElementById("description").innerHTML = data.description;
      });
      edit_container.classList.toggle('d-none');
      details_container.classList.toggle('d-none');
      edit_photo.classList.toggle('d-none');
    } else if (res.status == 400) {
      res.json().then(data => {
        let error = document.getElementById("error-message");
        error.textContent = data.message;
        error.classList.toggle('d-none');
        setTimeout(function () {
          let error = document.getElementById("error-message");
          error.textContent = "";
          error.classList.toggle('d-none');
        }, 3000);
      });
    } else console.log(res.status);
  })

  //console.log({ username, firstName, lastName, email, phone, password, confirmPassword, city, description });
  //sendAjaxRequest("post", `../api/users/${id}`, { username, firstName, lastName, email, phone, password, confirmPassword, city, description }, updateUserHandler);
}


let $modal = $('#editImageModal');
const fileInput = document.querySelector("#file02");
let cropper;

$modal.on('shown.bs.modal', function () {
  cropper = new Cropper(document.querySelector('#profile-photo'), {
    viewMode: 2,
    aspectRatio: 1,
    movable: true,
  });
}).on('hidden.bs.modal', function () {
  cropper.destroy();
  cropper = null;
  let label = document.querySelector('.custom-file-label');
  label.textContent = "Choose file";
});


fileInput.addEventListener('change', event => {
  let input = event.srcElement;
  let filename = input.files[0].name;
  let label = document.querySelector('.custom-file-label');
  label.textContent = filename;
});

fileInput.addEventListener('change', () => {
  if (fileInput.files && fileInput.files[0]) {
    let reader = new FileReader();

    reader.onload = function (e) {
      document.querySelector('#profile-photo').setAttribute('src', e.target.result);
      cropper.replace(e.target.result);
    }

    reader.readAsDataURL(fileInput.files[0]);
  }
});

const save_button = document.querySelector('#save');

save_button.addEventListener('click', event => {
  event.preventDefault();
  cropper.getCroppedCanvas().toBlob((blob) => {
    url = URL.createObjectURL(blob);
    let reader = new FileReader();
    reader.readAsDataURL(blob);
    reader.onloadend = () => {
      let base64data = reader.result;
      let image = document.querySelector('#profile-photo');

      fetch(`/api/users/${image.dataset.user}/photo`, {
        method: 'POST',
        body: JSON.stringify({
          base64data
        }),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content'),
        }
      }).then((res) => {
        if (res.ok) {
          res.json().then(data => {
            console.log(data.photo);
            let profile_image = document.querySelector('img.card-img-top:nth-child(2)');
            profile_image.setAttribute('src', `/assets/avatars/${data.photo}.png`);

            $modal.modal('hide');

            document.querySelector('#profile-photo').remove();
            document.getElementById('imag-wrapper').innerHTML = `
              <img
                id="profile-photo"
                class="card-img-top"
                src="/assets/avatars/${data.photo}.png"
                alt="User Avatar"
                style="width: 271px; height: 271px;"
                data-user="${image.dataset.user}"
              />
            `;
          });
        }
      })
    }
  });
});