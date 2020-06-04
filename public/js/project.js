const editProjectButton = document.getElementById("edit-project");
const saveProjectButton = document.getElementById("save-project");
let projectTitle = document.getElementById("project-title");
let projectDescription = document.getElementById("project-description");

let previous_state = {};

previous_state = {
  id : saveProjectButton.dataset.project ,
  title : projectTitle.innerHTML ,
 description : projectDescription.innerHTML,

 }



editProjectButton.addEventListener("click", () => {
  projectTitle.style.border = "1px solid rgba(82, 82, 82, 0.329)";
  projectTitle.style.borderRadius = "5px";
  projectTitle.style.background = "white";
  projectTitle.contentEditable = "true";
  projectDescription.style.border = "1px solid rgba(82, 82, 82, 0.329)";
  projectDescription.style.borderRadius = "5px";
  projectDescription.style.background = "white";
  projectDescription.contentEditable = "true";

  editProjectButton.style.display = "none";
  saveProjectButton.style.display = "inline-block";
})

saveProjectButton.addEventListener("click", () => {
  projectTitle.style.border = "none";
  projectTitle.style.borderRadius = "none";
  projectTitle.style.background = "none";
  projectTitle.contentEditable = "false";
  projectDescription.style.border = "none";
  projectDescription.style.borderRadius = "none";
  projectDescription.style.background = "none";
  projectDescription.contentEditable = "false";

  let id = saveProjectButton.dataset.project;
  let title = projectTitle.innerHTML;
  let description = projectDescription.innerHTML;
  console.log({ id, title, description });
  sendAjaxRequest("put", `/api/projects/${id}`, { title, description }, updateProjectHandler);


  editProjectButton.style.display = "inline-block";
  saveProjectButton.style.display = "none";
})

function updateProjectHandler() {
  const response = JSON.parse(this.responseText);
  
  if ('errors' in response) {
    displayError(response)
    saveProjectButton.dataset.project = previous_state.id;
    projectTitle.innerHTML = previous_state.title;
    projectDescription.innerHTML = previous_state.description;
  }

  console.log(response)
}
