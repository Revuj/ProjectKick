@extends('layouts.app', ['hide_navbar' => true, 'hide_footer' => false, 'sidebar' => 'none'])

@section('title', 'Kick | Contact us')

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
  <link rel="stylesheet" href="{{ asset('css/auth.css') }}" />
  <link rel="stylesheet" href="{{ asset('css/contact.css') }}" />
@endsection

@section('script')
  <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
    integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
    integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
    crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
    integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
    crossorigin="anonymous"></script>
  <script src="{{asset('js/index.js')}}" defer></script>


@endsection

@section('content')

<nav id="main-nav" class="navbar navbar-expand-lg navbar-light">
      <a class="navbar-brand ml-4" href="/">
        <h4><i class="fas fa-drafting-compass"></i> Kick</h4>
      </a>
      <button
        class="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
          <!-- <li class="nav-item active">
        <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#">Link</a>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Dropdown
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
          <a class="dropdown-item" href="#">Action</a>
          <a class="dropdown-item" href="#">Another action</a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" href="#">Something else here</a>
        </div>
      </li>
      <li class="nav-item">
        <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
      </li> -->
        </ul>
        <span class="mt-2 mr-4">
          <label id="switch" class="switch">
          <input type="checkbox" onchange="toggleTheme()" id="slider">
          <span class="slider round"></span>
        </span>
        <a href="/login" class="btn mr-4">Login</a>
        <a href="/register" class="btn mr-4">Signup</a>
      </div>
    </nav>
      <div class="main-container">
        <div class="main-content-container px-2">
        <div id="contact-us" class="text-left">
          <h3 id="contact-us-title" class="title task-title pb-2 mt-5 mb-0 font-weight-bold">Contact us</h3>
          @if (!empty($status))
            <div class="alert alert-success" role="alert">
              {{ $status }}
            </div>
          @endif
          <form id="contact-us-form" class="py-4 p-3" method="POST" action="{{ route('contact') }}">
            {{ csrf_field() }}
            <div class="row">
              <div class="form-group col-sm-12">
                <label for="name">Name</label>
                <input name="name" type="text" class="form-control @if ($errors->has('name')) is-invalid  @endif" id="name" placeholder="Enter your name">
                @if ($errors->has('name'))
                  <span class="text-danger">
                    {{ $errors->first('name') }}
                  </span>
                @endif
              </div>

              <div class="form-group col-sm-12">
                <label for="email">Email</label>
                <input name="email" type="text" class="form-control @if ($errors->has('email')) is-invalid  @endif" id="email" placeholder="Enter your email">
                @if ($errors->has('email'))
                  <span class="text-danger">
                    {{ $errors->first('email') }}
                  </span>
                @endif
              </div>

              <div class="form-group col-sm-12">
                <label for="message">Please enter your message here...</label>
                <textarea name="message" class="form-control" id="message" rows="3"></textarea>
            </div>
            </div>
            <div class="d-flex justify-content-end">
            <button id="submit-contact" type="submit" class="btn btn-success">Submit</button>
          </div>
          </form>

        </div>

      </div>
      </div>
  </div>


@endsection
