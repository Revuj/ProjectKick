@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true])

@section('title', 'Kick | Team members')

@section('script')
<script
      src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
      integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
      integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
      integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
      crossorigin="anonymous"
    ></script>
    <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>

    <script src="{{asset('js/index.js')}}" defer></script>
    <script src="{{asset('js/project_team.js')}}" defer></script>

@endsection

@section('style')
    <!-- Styles -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
      integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw="
      crossorigin="anonymous"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
      integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw="
      crossorigin="anonymous"
    />
    <link
      rel="stylesheet"
      href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
      integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
      crossorigin="anonymous"
    />
    <link rel="stylesheet" href="{{ asset('css/project_team.css') }}" />
    <link rel="stylesheet" href="{{ asset('css/navbar.css') }}"/>
@endsection

@section('content')
<div class="main-content-container px-4">
          <nav>
            <ol class="breadcrumb custom-separator">
              <li><a href="#0">lbaw</a></li>
              <li><a href="#0">Project Overview</a></li>
              <li class="current">Project Members</li>
            </ol>
          </nav>
          <div id="tables-types" class="d-flex border-bottom nav-links pb-2">
            <li class="active">
              Developer <span class="tables-type-counter">6</span>
            </li>
            <li>Coordinator <span class="tables-type-counter">3</span></li>
            <button
              type="button"
              data-toggle="modal"
              data-target="#addMemberModal"
              class="btn btn-success ml-auto "
            >
              <i class="fa fa-plus-circle fa-lg"></i>
              <span>Add Member</span>
            </button>
          </div>
          <div id="filter-issues" class="border-bottom py-3 my-0">
            <form class="d-md-flex justify-content-between">
              <div class="form-group mb-0 flex-grow-1">
                <input
                  type="text"
                  class="form-control"
                  name="issues-filter"
                  id="issues-filter"
                  placeholder="Search or filter results..."
                />
              </div>
              <div id="filter-buttons" class="dropdown ml-1">
                <button
                  data-toggle="dropdown"
                  aria-haspopup="true"
                  aria-expanded="false"
                  id="dropdownFiltersButton"
                  type="button"
                  type="submit"
                  class="custom-button primary-button dropdown-toggle"
                >
                  Sort by<i class="fas fa-chevron-down ml-3"></i>
                </button>
                <div
                  class="dropdown-menu"
                  aria-labelledby="dropdownFiltersButton"
                >
                  <a class="dropdown-item" href="#">Due Date</a>
                  <a class="dropdown-item" href="#">Opening Date</a>
                  <a class="dropdown-item" href="#">Assignees</a>
                </div>
                <button type="submit" class="custom-button primary-button">
                  <i class="fas fa-arrow-up"></i>
                </button>
              </div>
            </form>
          </div>
          <div class="row m-2">
            <div class="mx-auto">
              <div class="main-box clearfix">
                <div class="table-responsive" id="developers">
                  <table class="table user-list">
                    <thead>
                      <tr>
                        <th class="font-weight-bold" style="width: 30%">
                          User
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          Joined
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          Email
                        </th>
                        <th class="font-weight-bold" style="width: 30%">
                          &nbsp;
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td data-label="User">
                          <img src="{{asset('assets/profile.png')}}" alt="" />
                          <a href="#" class="user-link">George Clooney</a>
                          <span class="user-subhead">Project Developer</span>
                        </td>
                        <td data-label="Joined">
                          2013/08/12
                        </td>
                        <td data-label="Email">
                          <a href="#">marlon@brando.com</a>
                        </td>
                        <td align="center">
                          <a href="#" class="table-link">
                            <button class="custom-button close-button">
                              <i class="fa fa-trash fa"></i>
                              Remove
                            </button>
                          </a>
                          <a href="#" class="table-link">
                            <button class="custom-button open-button ">
                              <i class="fa fa-arrow-alt-circle-up"></i>
                              Promote
                            </button>
                          </a>
                        </td>
                      </tr>
                      <tr>
                        <td data-label="User">
                        <img src="{{asset('assets/profile.png')}}" alt="" />                          <a href="#" class="user-link">Ryan Gossling</a>
                          <span class="user-subhead">Project Developer</span>
                        </td>
                        <td data-label="Joined">
                          2013/03/03
                        </td>

                        <td data-label="Email">
                          <a href="#">jack@nicholson</a>
                        </td>
                        <td align="center">
                          <a href="#" class="table-link">
                            <button class="custom-button close-button">
                              <i class="fa fa-trash fa"></i>
                              Remove
                            </button>
                          </a>
                          <a href="#" class="table-link">
                            <button class="custom-button open-button ">
                              <i class="fa fa-arrow-alt-circle-up"></i>
                              Promote
                            </button>
                          </a>
                        </td>
                      </tr>
                      <tr>
                        <td data-label="User">
                        <img src="{{asset('assets/profile.png')}}" alt="" />                          <a href="#" class="user-link">Emma Watson</a>
                          <span class="user-subhead">Project Developer</span>
                        </td>
                        <td data-label="Joined">
                          2004/01/24
                        </td>
                        <td data-label="Email">
                          <a href="#">humphrey@bogart.com</a>
                        </td>
                        <td align="center">
                          <a href="#" class="table-link">
                            <button class="custom-button close-button">
                              <i class="fa fa-trash fa"></i>
                              Remove
                            </button>
                          </a>
                          <a href="#" class="table-link">
                            <button class="custom-button open-button ">
                              <i class="fa fa-arrow-alt-circle-up"></i>
                              Promote
                            </button>
                          </a>
                        </td>
                      </tr>
                      <tr>
                        <td data-label="User">
                        <img src="{{asset('assets/profile.png')}}" alt="" />                          <a href="#" class="user-link">George Clooney</a>
                          <span class="user-subhead">Project Developer</span>
                        </td>
                        <td data-label="Joined">
                          2013/08/12
                        </td>

                        <td data-label="Email">
                          <a href="#">marlon@brando.com</a>
                        </td>
                        <td align="center">
                          <a href="#" class="table-link">
                            <button class="custom-button close-button">
                              <i class="fa fa-trash fa"></i>
                              Remove
                            </button>
                          </a>
                          <a href="#" class="table-link">
                            <button class="custom-button open-button ">
                              <i class="fa fa-arrow-alt-circle-up"></i>
                              Promote
                            </button>
                          </a>
                        </td>
                      </tr>
                      <tr>
                        <td data-label="User">
                        <img src="{{asset('assets/profile.png')}}" alt="" />                          <a href="#" class="user-link">Ryan Gossling</a>
                          <span class="user-subhead">Project Developer</span>
                        </td>
                        <td data-label="Joined">
                          2013/03/03
                        </td>

                        <td data-label="Email">
                          <a href="#">jack@nicholson</a>
                        </td>
                        <td align="center">
                          <a href="#" class="table-link">
                            <button class="custom-button close-button">
                              <i class="fa fa-trash fa"></i>
                              Remove
                            </button>
                          </a>
                          <a href="#" class="table-link">
                            <button class="custom-button open-button ">
                              <i class="fa fa-arrow-alt-circle-up"></i>
                              Promote
                            </button>
                          </a>
                        </td>
                      </tr>
                      <tr>
                        <td data-label="User">
                        <img src="{{asset('assets/profile.png')}}" alt="" />                          <a href="#" class="user-link">Emma Watson</a>
                          <span class="user-subhead">Project Developer</span>
                        </td>
                        <td data-label="Joined">
                          2004/01/24
                        </td>

                        <td data-label="Email">
                          <a href="#">humphrey@bogart.com</a>
                        </td>
                        <td align="center">
                          <a href="#" class="table-link">
                            <button class="custom-button close-button">
                              <i class="fa fa-trash fa"></i>
                              Remove
                            </button>
                          </a>
                          <a href="#" class="table-link">
                            <button class="custom-button open-button ">
                              <i class="fa fa-arrow-alt-circle-up"></i>
                              Promote
                            </button>
                          </a>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="table-responsive d-none" id="coordinators">
                  <table class="table user-list">
                    <thead>
                      <tr>
                        <th class="font-weight-bold" style="width: 40%">
                          User
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          Joined
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          Email
                        </th>
                        <th class="font-weight-bold" style="width: 20%">
                          &nbsp;
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td data-label="User">
                        <img src="{{asset('assets/profile.png')}}" alt="" />                          <a href="#" class="user-link">Mila Kunis</a>
                          <span class="user-subhead">Project Coordinator</span>
                        </td>
                        <td data-label="Joined">
                          2013/08/08
                        </td>
                        <td data-label="Email">
                          <a href="#">mila@kunis.com</a>
                        </td>
                        <td align="center">
                          <a href="#" class="table-link">
                            <button class="custom-button close-button">
                              <i class="fa fa-sign-out fa"></i>
                              Leave
                            </button>
                          </a>
                        </td>
                      </tr>
                      <tr>
                        <td data-label="User">
                        <img src="{{asset('assets/profile.png')}}" alt="" />                          <a href="#" class="user-link">Robert Downey Jr.</a>
                          <span class="user-subhead">Project Coordinator </span>
                        </td>
                        <td data-label="Joined">
                          2013/12/31
                        </td>

                        <td data-label="Email">
                          <a href="#">spencer@tracy</a>
                        </td>
                        <td align="center">
                          <a href="#" class="table-link">
                            <button class="custom-button close-button">
                              <i class="fa fa-sign-out fa"></i>
                              Leave
                            </button>
                          </a>
                        </td>
                      </tr>
                      <tr>
                        <td data-label="User">
                        <img src="{{asset('assets/profile.png')}}" alt="" />                          <a href="#" class="user-link">Mila Kunis</a>
                          <span class="user-subhead">Project Coordinator</span>
                        </td>
                        <td data-label="Joined">
                          2013/08/08
                        </td>

                        <td data-label="Email">
                          <a href="#">mila@kunis.com</a>
                        </td>
                        <td align="center">
                          <a href="#" class="table-link">
                            <button class="custom-button close-button">
                              <i class="fa fa-sign-out fa"></i>
                              Leave
                            </button>
                          </a>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

            <div class="d-flex mt-3">
              <nav class="" aria-label="Page navigation example">
                <ul class="pagination">
                  <li class="page-item">
                    <a href="#" class="page-link" aria-label="Previous"
                      ><span aria-hidden="true"
                        ><i class="fa fa-fw fa-angle-left"></i></span
                      ><span class="sr-only">Previous</span></a
                    >
                  </li>
                  <li class="page-item active">
                    <a href="#" class="page-link">1</a>
                  </li>
                  <li class="page-item">
                    <a href="#" class="page-link">2</a>
                  </li>
                  <li class="page-item">
                    <a href="#" class="page-link">3</a>
                  </li>
                  <li class="page-item">
                    <a href="#" class="page-link" aria-label="Next"
                      ><span aria-hidden="true"
                        ><i class="fa fa-fw fa-angle-right"></i></span
                      ><span class="sr-only">Next</span></a
                    >
                  </li>
                </ul>
              </nav>
            </div>
          </div>
        </div>
        <div
          class="modal"
          id="addMemberModal"
          tabindex="-1"
          role="dialog"
          aria-labelledby="addMemberModalLabel"
          aria-hidden="true"
        >
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="addMemberModalLabel">
                  Add Member
                </h5>
                <button
                  type="button"
                  class="close"
                  data-dismiss="modal"
                  aria-label="Close"
                >
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <form>
                  <div class="form-group">
                    <label for="email" class="col-form-label">Username</label>
                    <input type="text" class="form-control" id="email" />
                  </div>
                  <div class="form-group">
                    <div class="btn-group" data-toggle="buttons">
                      <label class="btn btn-outline-primary">
                        <input type="radio" name="options" id="option1" />
                        Project Developer
                      </label>
                      <label class="btn btn-outline-primary">
                        <input type="radio" name="options" id="option2" />
                        Project Coordinator
                      </label>
                    </div>
                  </div>
                </form>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn " data-dismiss="modal">
                  Close
                </button>
                <button type="button" class="btn btn-success">
                  Add Member
                </button>
              </div>
            </div>
          </div>
        </div>

@endsection