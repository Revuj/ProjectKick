@extends('layouts.app', ['hide_navbar' => true, 'hide_footer' => true, 'sidebar' => 'none'])

@section('title', 'Kick | Email Reset')


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
      <a class="nostyle" href="/">
        <h4 class="mb-0 px-3">
          <i class="fas fa-drafting-compass"></i> Kick
        </h4>
      </a>
    </div>

    @if (session('message'))
        <div class="alert alert-danger mx-2">
        <i class="fas fa-exclamation-triangle"></i>
        {{ session('message') }}
        </div>
    @endif

    <div class="row">
      <div class="col-md-6 d-none d-md-block">
        <div id="carouselExampleFade" class="carousel slide carousel-fade mb-3" data-ride="carousel">
          <div class="carousel-inner">
            <div class="carousel-item active">
              <h5 class="text-secondary px-3">Distribute the work</h5>
              <img src="/assets/svg/undraw_public_discussion_btnw.svg" class="d-block w-100 max-300" alt="..." />
            </div>
            <div class="carousel-item">
              <h5 class="text-secondary px-3">Create goals</h5>
              <img src="/assets/svg/undraw_reviewed_docs_neeb.svg" class="d-block w-100 max-300" alt="..." />
            </div>
            <div class="carousel-item">
              <h5 class="text-secondary px-3">Manage every task</h5>
              <img src="/assets/svg/undraw_scrum_board_cesn.svg" class="d-block w-100 max-300" alt="..." />
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
        @if (session('status'))
                        <div class="alert alert-success" role="alert">
                            {{ session('status') }}
                        </div>
                    @endif

                    <form method="POST" action="{{ route('password.email') }}">
                    {{ csrf_field() }}

                        <div class="form-group mt-3">
                            <label for="email" class="">{{ __('E-Mail Address') }}</label>

                                <input id="email" type="email" class="form-control @error('email') is-invalid @enderror" name="email" value="{{ old('email') }}" required autocomplete="email" autofocus>

                                @error('email')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                        </div>

                        <div class="form-group">
                            <div class="">
                                <button type="submit" class="btn btn-success">
                                    {{ __('Send Password Reset Link') }}
                                </button>
                            </div>
                        </div>
                    </form>
    </div>

    </div>
</div>

@endsection
