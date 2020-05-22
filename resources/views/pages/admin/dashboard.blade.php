@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'admin'])

@section('title', 'Admin | Dashboard')

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="{{asset('css/admin.css')}}" />
    <link rel="stylesheet" href="{{asset('css/navbar.css')}}" />
@endsection

@section('script')
    <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
    <script
      src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
      integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
      integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
      integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
      crossorigin="anonymous"
    ></script>
    <script src="https://www.amcharts.com/lib/4/core.js"></script>
    <script src="https://www.amcharts.com/lib/4/maps.js"></script>
    <script src="https://www.amcharts.com/lib/4/geodata/worldLow.js"></script>
    <script src="https://www.amcharts.com/lib/4/themes/animated.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.3/dist/Chart.min.js"></script>
    <script src="js/libs/chartjs-plugin-doughnutlabel.min.js"></script>
    <script src="{{asset('js/index.js')}}" defer></script>
    <script src="{{asset('js/admin.js')}}" defer></script>
@endsection

@section('content')
<div class="main-content-container px-4">
  <div class="row">
    <div class="col-xl-12 col-lg-9 col-md-8 ml-auto">
      <div class="row pt-md-5 mt-md-3 mb-5">



        <div class="col-xl-3 col-sm-6 p-2">
          <div class="card card-common">
            <div class="card-body">
              <div class="d-flex justify-content-between">
              <i class="fas fa-project-diagram fa-3x  text-info"></i>
                <div class="text-right text-secondary">
                  <h5 class="h5">Project Number</h5>
                  <h3 id = "number-projects" class = "text-center">{{$projects}}</h3>
                </div>
              </div>
            </div>
            <div class="card-footer text-secondary clickable" id = "project-update">
              <i class="fas fa-sync mr-3 reload"></i>
              <span>Updated Now</span>
            </div>
          </div>
        </div>

        <div class="col-xl-3 col-sm-6 p-2">
          <div class="card card-common">
            <div class="card-body">
              <div class="d-flex justify-content-between">
                <i class="fas fa-tasks fa-3x text-success"></i>
                <div class="text-right text-secondary">
                  <h5 class="h5">Closed tasks</h5>
                  <h3 id = "number-tasks" class = "text-center">{{$closed_tasks}}</h3>
                </div>
              </div>
            </div>
            <div class="card-footer text-secondary clickable" id = "task-update">
              <i class="fas fa-sync mr-3 reload"></i>
              <span>Updated Now</span>
            </div>
          </div>
        </div>


        <div class="col-xl-3 col-sm-6 p-2">
          <div class="card card-common">
            <div class="card-body">
              <div class="d-flex justify-content-between">
                <i class="fas fa-users fa-3x text-info"></i>
                <div class="text-right text-secondary px-3">
                  <h5 class = "h5">Users</h5>
                  <h3 id = "number-users" class = "text-center">{{$nr_users}}</h3>
                </div>
              </div>
            </div>
            <div class="card-footer text-secondary clickable" id = "user-update">
              <i class="fas fa-sync mr-3 reload"></i>
              <span>Updated Now</span>
            </div>
          </div>
        </div>

        <div class="col-xl-3 col-sm-6 p-2">
          <div class="card card-common">
            <div class="card-body">
              <div class="d-flex justify-content-between">
                <i class="fas fa-chart-line fa-3x text-danger"></i>
                <div class="text-right text-secondary px-3">
                  <h5 class = "h5">Closed Reports</h5>
                  <h3 id = "number-reports" class = "text-center"> {{$nr_reports}}</h3>
                </div>
              </div>
            </div>
            <div class="card-footer text-secondary clickable" id = "report-update">
              <i class="fas fa-sync mr-3 reload"></i>
              <span>Updated Now</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- end of row-->

  <!--earth -->
  <div class = "w-100" id="chartdiv"></div>

  <!--EVOLUTION GRAPH-->
  <div class="container-fluid">
    <div class="row">
      <div class="col-xs-6 col-md-6">
        <canvas class="graph-item" id="line-chart"></canvas>
      </div>
      <div class="col-xs-6 col-md-6">
        <canvas class="graph-item" id="doughnut-chart"></canvas>
      </div>
    </div>
  </div>

  <div class="container-fluid">
    <div class="row">
      <div class="col-xs-6 col-md-6">
        <table class="table table-striped">
          <caption>
            Banned users
          </caption>
          <thead>
            <tr>
              <th scope="col">Name</th>
              <th scope="col">Start Date</th>
              <th scope="col">End date</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td data-label="Name">Mark Otto</td>
              <td data-label="Start Date">12-3-2019</td>
              <td data-label="End Date">12-3-2019</td>
            </tr>
            <tr>
              <td data-label="Name">Mark Otto</td>
              <td data-label="Start Date">12-3-2019</td>
              <td data-label="End Date">12-3-2019</td>
            </tr>
            <tr>
              <td data-label="Name">Mark Otto</td>
              <td data-label="Start Date">12-3-2019</td>
              <td data-label="End Date">12-3-2019</td>
            </tr>
            <tr>
              <td data-label="Name">Mark Otto</td>
              <td data-label="Start Date">12-3-2019</td>
              <td data-label="End Date">12-3-2019</td>
            </tr>
            <tr>
              <td data-label="Name">Mark Otto</td>
              <td data-label="Start Date">12-3-2019</td>
              <td data-label="End Date">12-3-2019</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="col-xs-6 col-md-6">
        <table class="table table-striped">
          <caption>
            New users
          </caption>

          <thead>
            <tr>
              <th scope="col">Users</th>
              <th scope="col">Date</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td data-label="Users">Mark Otto</td>
              <td data-label="Date">12-3-2019</td>
            </tr>
            <tr>
              <td data-label="Users">Mark Otto</td>
              <td data-label="Date">12-3-2019</td>
            </tr>
            <tr>
              <td data-label="Users">Mark Otto</td>
              <td data-label="Date">12-3-2019</td>
            </tr>
            <tr>
              <td data-label="Users">Mark Otto</td>
              <td data-label="Date">12-3-2019</td>
            </tr>
            <tr>
              <td data-label="Users">Mark Otto</td>
              <td data-label="Date">12-3-2019</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
@endsection
