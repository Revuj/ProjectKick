@extends('layouts.app', ['hide_navbar' => true, 'hide_footer' => true, 'sidebar' => 'none'])

@section('title', 'Kick | Authenticate')

@section('script')
  <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
  <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
    integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
    crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
    integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
    crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
    integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
    crossorigin="anonymous"></script>
  <script src="{{asset('js/index.js')}}" defer></script>
@endsection

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />

  <link rel="stylesheet" href="{{asset('css/auth.css')}}"/>
@endsection


@section('content')
<div class="container mt-5 shadow-lg rounded">

    <div class="logo py-3 px-3">
      <a class="nostyle" href="index.html">
        <h4 class="mb-0 px-3">
          <i class="fas fa-drafting-compass"></i> Kick
        </h4>
      </a>
     </div>

    <div class="row">

      <div class="col-md-6 d-none d-md-block">
        <div id="carouselExampleFade" class="carousel slide carousel-fade mb-3" data-ride="carousel">
          <div class="carousel-inner">
            <div class="carousel-item active">
              <h5 class="text-secondary px-3">Distribute the work</h5>
              <img src="./assets/svg/undraw_public_discussion_btnw.svg" class="d-block w-100 max-300" alt="..." />
            </div>
            <div class="carousel-item">
              <h5 class="text-secondary px-3">Create goals</h5>
              <img src="./assets/svg/undraw_reviewed_docs_neeb.svg" class="d-block w-100 max-300" alt="..." />
            </div>
            <div class="carousel-item">
              <h5 class="text-secondary px-3">Manage every task</h5>
              <img src="./assets/svg/undraw_scrum_board_cesn.svg" class="d-block w-100 max-300" alt="..." />
            </div>
          </div>

          <a class="carousel-control-prev" href="#carouselExampleFade" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
          </a>
          <a class="carousel-control-next" href="#carouselExampleFade" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
          </a>
        </div>
      </div>

      <div id="signup-form" class="col-md-6 col-sm-8 signup-form py-4 pr-5">
        <form method="POST" action="{{ route('register') }}" class="d-flex flex-column">
        @csrf
          <h3>Create an account</h3>

          <div class="form-group mt-3">
            <label for="email_register">{{ __('Email Address') }}</label>
            <input name = "email" type="email" class="form-control @error('email') is-invalid @enderror" id="email_register" value="{{app('request')->input('email')}}"/>
            @if ($errors->has('email'))
              <span class="text-danger">
                {{ $errors->first('email') }}
              </span>
            @endif
          </div>

          <div class="form-group">
            <label for="username">Username</label>
            <input name = "username" type="text" class="form-control @error('username') is-invalid @enderror" id="username" autocomplete="new-username"/>
            @if ($errors->has('username'))
              <span class="text-danger">
                {{ $errors->first('username') }}
              </span>
            @endif
          </div>

          <div class="form-group">
            <label for="name">Name</label>
            <input name = "name" type="text" class="form-control @error('name') is-invalid @enderror" id="name" autocomplete="name"/>
            @if ($errors->has('name'))
              <span class="text-danger">
                {{ $errors->first('name') }}
              </span>
            @endif
          </div>

          <div class="form-group">
            <label for="passord_register">{{ __('Password') }}</label>
            <input id="passord_register" type="password" class="form-control @error('password') is-invalid @enderror" name="password"  autocomplete="new-password">
            @if ($errors->has('password'))
              <span class="text-danger">
                {{ $errors->first('password') }}
              </span>
            @endif
          </div>

          <div class="form-group">
            <label for="password-confirm">{{ __('Confirm Password') }}</label>
            <input id="password-confirm" type="password" class="form-control @error('password') is-invalid @enderror" name="password_confirmation"  autocomplete="new-password">
          </div>

          <div class="d-flex justify-content-end">
            <button type="submit" class="custom-button secondary-button" id="signup-button">
              Sign up
            </button>
          </div>

          <p class="text-center mt-2">
            Already have an account? <a href = "{{route('login')}}" > Log in</a>
          </p>
        </form>
        </div>
    </div>
</div>