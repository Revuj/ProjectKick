@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'user'])

@section('title', 'Kick | Profile ')

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
    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.3/dist/Chart.min.js"></script>
    <script src="{{asset('js/libs/chartjs-plugin-doughnutlabel.min.js')}}"></script>

    <script src="{{asset('js/index.js')}}" defer></script>
    <script src="{{asset('js/profile.js')}}" defer></script>
@endsection

@section('style')
    <!-- Styles -->
    <link
      rel="stylesheet"
      href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
      integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
      crossorigin="anonymous"
    />
    <link rel="stylesheet" href="{{ asset('css/profile.css') }}" />
    <link rel="stylesheet" href="{{ asset('css/navbar.css') }}"/>
@endsection


@section('content')
<div class="main-content-container px-4">
          <nav>
            <ol class="breadcrumb custom-separator">
              <li class="current">Profile</li>
            </ol>
          </nav>
          <!-- Default Light Table -->
          <div class="row">
            <div class="col-md-4">
              <div  class="card card-small mb-4 user">
                @if ($editable)
                  <div class="edit-button">
                    <button type="button" class="btn float-right">
                      <i class="fas fa-pencil-alt float-right"></i>
                    </button>
                  </div>
                @endif
                <img
                  class="card-img-top"
                  src="{{asset('assets/profile.png')}}"
                  alt="User Avatar"
                  width="110"
                />
                <ul class="list-group list-group-flush mt-2">
                  <li class="list-group-item p-2">
                    <h4 id="username" class="title mb-0 mt-2">{{ $username }}</h4>
                    <span id="country" class="text-muted d-block mb-1">Porto, {{ $country }}</span>
                    <div class="mb-4 mt-3">
                      <span id="description" class="smaller-text"
                        >{{ $description }}</span
                      >
                    </div>
                  </li>
                </ul>
                <div class="d-flex justify-content-left card-footer">
                  <ul class="labels d-flex justify-content-center mx-2">
                    <li class="mr-2">
                      <h6 class="mb-0 px-1 list-item-label bg-success">
                        lbaw
                      </h6>
                    </li>
                    <li class="mr-2">
                      <h6 class="mb-0 px-1 list-item-label bg-warning">
                        html
                      </h6>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="col-md-8" id="details">
              <div class="card card-small mb-4">
                <div class="card-header border-bottom">
                  <h6 class="m-0">Account Details</h6>
                </div>
                <ul class="list-group list-group-flush">
                  <li class="list-group-item p-3">
                    <div class="row">
                      <div class="col">
                        <label>Email</label>
                        <p id="email" class="font-weight-bold">{{ $email }}</p>
                      </div>
                      <div class="col">
                        <label>Phone</label>
                        <p id="phone_number" class="font-weight-bold">{{ $phone_number }}</p>
                      </div>
                    </div>
                    <div class="row py-3">
                      <div class="col-md-6 py-3">
                        <canvas data-assigned-issues="{{ $assigned_issues }}" data-completed-issues="{{ $completed_issues }}" id="doughnut-chart-task"></canvas>
                      </div>
                      <div class="col-md-6 py-3">
                        <canvas  data-open-projects="{{ $open_projects }}" data-closed-projects="{{ $closed_projects }}" id="doughnut-chart-project"></canvas>
                      </div>
                    </div>
                    <div class="row my-10">
                      <div class="col-md-12">
                        <canvas id="bar-chart-activity"></canvas>
                      </div>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
            <div class="col-md-8 d-none" id="edit">
              <div class="card card-small mb-4">
                <div class="card-header border-bottom d-flex">
                  <h6 class="m-0">Edit Account</h6>
                  <button class="btn p-0 ml-auto" id="close-edit">
                    <i class="fas fa-times"></i>
                  </button>
                </div>
                <ul class="list-group list-group-flush">
                  <li class="list-group-item pt-0">
                    <div class="row">
                      <div class="col">
                        <form class="mt-3">
                          <div class="form-row">
                            <div class="form-group col-md-12 w-50">
                              <label for="feFirstName">Username</label>
                              <input
                                type="text"
                                class="form-control"
                                id="feUsername"
                                placeholder="username"
                                value="{{ $username }}"
                              />
                            </div>
                            <div class="form-group col-md-6">
                              <label for="feFirstName">First Name</label>
                              <input
                                type="text"
                                class="form-control"
                                id="feFirstName"
                                placeholder="First Name"
                                value="{{ $first_name }}"
                              />
                            </div>
                            <div class="form-group col-md-6">
                              <label for="feLastName">Last Name</label>
                              <input
                                type="text"
                                class="form-control"
                                id="feLastName"
                                placeholder="Last Name"
                                value="{{ $last_name }}"
                              />
                            </div>
                          </div>
                          <div class="form-row">
                            <div class="form-group col-md-6">
                              <label for="feEmail">Email</label>
                              <input
                                type="text"
                                class="form-control"
                                id="feEmail"
                                placeholder="Email"
                                value="{{ $email }}"
                              />
                            </div>
                            <div class="form-group col-md-6">
                              <label for="fePhone">Phone</label>
                              <input
                                type="text"
                                class="form-control"
                                id="fePhone"
                                placeholder="Phone"
                                value="{{ $phone_number }}"
                              />
                            </div>
                          </div>

                          <div class="form-row">
                            <div class="form-group col-md-6">
                              <label for="fePassword">Password</label>
                              <input
                                type="password"
                                class="form-control"
                                id="fePassword"
                                placeholder="Password"
                              />
                            </div>
                            <div class="form-group col-md-6">
                              <label for="feConfirmPassword"
                                >Confirm Password</label
                              >
                              <input
                                type="password"
                                class="form-control"
                                id="feConfirmPassword"
                                placeholder="Confirm Password"
                              />
                            </div>
                          </div>
                          <div class="form-row">
                            <div class="form-group col-md-6">
                              <label for="feCity">City</label>
                              <input
                                type="text"
                                class="form-control"
                                id="feCity"
                                placeholder="City"
                                value="Porto"
                              />
                            </div>
                            <div class="form-group col-md-6">
                              <label for="feCountry">Country</label>
                              <input
                                type="text"
                                class="form-control"
                                id="feCountry"
                                placeholder="Country"
                                value="{{ $country }}"
                              />
                            </div>
                          </div>
                          <div class="form-row">
                            <div class="form-group col-md-12">
                              <label for="feDescription">Description</label>
                              <textarea
                                id="feDescription"
                                class="form-control"
                                name="feDescription"
                                rows="5"
                              >
                                {{ $description }}
                              </textarea>
                            </div>
                          </div>
                          <div class="d-md-flex profile-edit-buttons">
                            <button
                              type="button"
                              class="mr-auto custom-button close-button"
                              data-toggle="modal"
                              data-target="#deleteModal"
                            >
                              Delete Account
                            </button>
                            <div>
                              <button
                                type="button"
                                class="btn cancel"
                                data-dismiss="modal"
                              >
                                Cancel
                              </button>
                              <button
                                type="button"
                                id="update"
                                class="btn btn-success"
                              >
                                Update Account
                              </button>
                            </div>
                          </div>
                        </form>
                      </div>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <!-- End Default Light Table -->
        </div>
      </div>
      <div
        class="modal"
        id="deleteModal"
        tabindex="-1"
        role="dialog"
        aria-labelledby="deleteModalLabel"
        aria-hidden="true"
      >
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="deleteModalLabel">Delete Account</h5>
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
              <p>
                If you do not think you will use Project Kick again and would
                like your account deleted, we can take care of this for you.
                Keep in mind that you will not be able to reactivate your
                account or retrieve any of the content or information you have
                added.
              </p>
            </div>
            <div class="modal-footer">
              <button type="button" id = "cancel" class="btn cancel" data-dismiss="modal">
                Cancel
              </button>
                <button
                  type="submit"
                  id="delete"
                  class="custom-button close-button"
                  data-user="{{ $user_id }}"
                >
                Delete Account
              </button>
            </div>
          </div>
        </div>
      </div>

@endsection
