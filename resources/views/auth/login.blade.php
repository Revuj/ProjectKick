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


     <div id="login-form" class="col-md-6 col-sm-8 login-form py-4 pr-5">
        <form method = "POST" action="{{ route('login') }}" class="d-flex flex-column" >
        @csrf
        <h3>Login your account</h3>

        <div class="form-group  mt-3">
            <label for="username">{{ __('Email or Username') }}</label>
            <input class = "form-control @error('username', 'email') is-invalid @enderror" autocomplete = "user_email" name = "username" type="text" value="{{ old('username') ?: old('email') }}" class="form-control" id="username"  autofocus/>
            @if ($errors->has('username'))
              <span class="text-danger">
                {{ $errors->first('username') }}
              </span>
            @endif
            @if ($errors->has('email'))
              <span class="text-danger">
                {{ $errors->first('email') }}
              </span>
            @endif
        </div>

        <div class="form-group">
            <label for="password">{{ __('Password') }}</label>
            <input id="password" type="password" class="form-control @error('password') is-invalid @enderror" name="password"  autocomplete="current-password">

            @if ($errors->has('password'))
              <span class="text-danger">
                {{ $errors->first('password') }}
              </span>
            @endif
        </div>


        <div class="form-group">
            <div class="form-check">
                <input class="form-check-input " type="checkbox" name="remember" id="remember" {{ old('remember') ? 'checked' : '' }}>

                <label class="form-check-label" for="remember">
                    {{ __('Remember Me') }}
                </label>
            </div>
        </div>

        <div class="form-group">
            <button type="submit" class="custom-button secondary-button">
                {{ __('Login') }}
            </button>

            @if (Route::has('password.request'))
                <a class="btn btn-link" href="{{ route('password.request') }}">
                    {{ __('Forgot Your Password?') }}
                </a>
            @endif
        </div>
        <p class="text-center mt-2">
            Don't have an account? <a href = "{{route('register')}}"> Sign Up</a>
          </p>
        </form>
    </div>

    </div>
</div>

@endsection


