@extends('layouts.app', ['hide_navbar' => !Auth::check(), 'hide_footer' => Auth::check(), 'sidebar' => (
Auth::check() ?
'project': 'none')])

@section('title', 'Kick | Help')

@section('style')
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
<link rel="stylesheet" href="{{asset('css/main.css')}}" />
<link rel="stylesheet" href="{{asset('css/navbar.css')}}" />

@endsection

@section('script')
<script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
    integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous">
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
    integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous">
</script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
    integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous">
</script>
<script src="{{asset('js/index.js')}}" defer></script>
@endsection


@section('content')
<nav id="main-nav" class="navbar navbar-expand-lg navbar-light">
    <a class="navbar-brand ml-4" href="/">
        @if (!Auth::check())
        <h4><i class="fas fa-drafting-compass"></i> Kick</h4>
        @endif
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
        </ul>
        <span class="mt-2 mr-4">
            <label id="switch" class="switch">
                <input type="checkbox" onchange="toggleTheme()" id="slider">
                <span class="slider round"></span>
        </span>
        @if (!Auth::check())
        <a href="/login" class="btn mr-4">Login</a>
        <a href="/register" class="btn mr-4">Signup</a>
        @endif
    </div>
</nav>
<div>
    <!-- Jumbotron -->
    <div id="preview" class="jumbotron mb-5">
        <div class="container">
            <div class="row">
                <div id="description" class="col-md-12 text-center">
                    <h1 class="font-weight-bold title" id="about-title">
                        Help Page
                    </h1>
                    <p class="lead">
                        Learn how to do things in a easy way!
                    </p>
                </div>
            </div>
        </div>
    </div>
    <div class="pb-5 mb-5">
        <div class="w-100 m-auto">


            <div class="accordion" id="accordionExample275">
                <div class="card z-depth-0 bordered w-100">
                    <div class="card-header" id="headingOne2">
                        <h5 class="mb-0 text-center">
                            <button class="btn author-reference" data-toggle="collapse" data-target="#collapseOne2"
                                aria-expanded="true" aria-controls="collapseOne2">
                                <span class="h4"> How to create a new project ?</span>
                            </button>
                        </h5>
                    </div>
                    <div id="collapseOne2" class="collapse" aria-labelledby="headingOne2"
                        data-parent="#accordionExample275">
                        <div class="card-body">
                            <div class="d-flex justify-content-center">
                                <ol class="h5">
                                    <li class="p-1"><span class="h5">1.</span> Have an account and be logged in</li>
                                    <li class="p-1"><span class="h5">2.</span> In the main menu go to the Dashboard
                                    </li>
                                    <li class="p-1"><span class="h5">3.</span> Click in the button Add Project</li>
                                    <li class="p-1"><span class="h5">4.</span> Lastly give it a name and a description
                                    </li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card z-depth-0 bordered">
                    <div class="card-header" id="headingTwo2">
                        <h5 class="mb-0 text-center">
                            <button class="btn author-reference" type="button" data-toggle="collapse"
                                data-target="#collapseTwo2" aria-expanded="false" aria-controls="collapseTwo2">
                                <span class="h4"> How to invite people to your project ?</span>
                            </button>
                        </h5>
                    </div>
                    <div id="collapseTwo2" class="collapse" aria-labelledby="headingTwo2"
                        data-parent="#accordionExample275">
                        <div class="card-body">
                            <div class="d-flex justify-content-center">
                                <ol class="h5">
                                    <li class="p-1"><span class="h5">1.</span> Go to a project of yours or one in where
                                        you are a coordinator</li>
                                    <li class="p-1"><span class="h5">2.</span> In the project menu click on Members
                                        inside the project overview
                                    </li>
                                    <li class="p-1"><span class="h5">3.</span> Click in the button Add Member</li>
                                    <li class="p-1"><span class="h5">4.</span>Write the username and specify its role
                                    </li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="card z-depth-0 bordered">
                    <div class="card-header" id="headingThree2">
                        <h5 class="mb-0 text-center">
                            <button class="btn author-reference" type="button" data-toggle="collapse"
                                data-target="#collapseThree2" aria-expanded="false" aria-controls="collapseThree2">
                                <span class="h4"> How to promote or remove someone of a project?</span>
                            </button>
                        </h5>
                    </div>
                    <div id="collapseThree2" class="collapse" aria-labelledby="headingThree2"
                        data-parent="#accordionExample275">
                        <div class="card-body">
                            <div class="d-flex justify-content-center">
                                <ol class="h5">
                                    <li class="p-1"><span class="h5">1.</span> Go to a project of yours or one in where
                                        you are a coordinator</li>
                                    <li class="p-1"><span class="h5">2.</span> In the project menu click on Members
                                        inside the project overview
                                    </li>
                                    <li class="p-1"><span class="h5">3.</span> In the members you can either promote or
                                        remove a member</li>
                                    <li class="p-1 text-center"> <small>Note: You can not only do that if the other is
                                            not a
                                            coordinator as well
                                        </small>
                                    </li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card z-depth-0 bordered">
                    <div class="card-header" id="heading4">
                        <h5 class="mb-0 text-center">
                            <button class="btn author-reference" type="button" data-toggle="collapse"
                                data-target="#collapseheading4" aria-expanded="false" aria-controls="collapseheading4">
                                <span class="h4"> How to go to your profile ?</span>
                            </button>
                        </h5>
                    </div>
                    <div id="collapseheading4" class="collapse" aria-labelledby="heading4"
                        data-parent="#accordionExample275">
                        <div class="card-body">
                            <div class="d-flex justify-content-center">
                                <ol class="h5">
                                    <li class="p-1"><span class="h5">1.</span> You have to be logged in</li>
                                    <li class="p-1"><span class="h5">2.</span> Click on the icon <i
                                            class="fas fa-user px-1"></i> in the navegation bar near the notifications
                                    </li>
                                    <li class="p-1"><span class="h5">3.</span> Click on the first option where is your
                                        username and profile picture</li>
                                    </li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card z-depth-0 bordered">
                    <div class="card-header" id="heading5">
                        <h5 class="mb-0 text-center">
                            <button class="btn author-reference" type="button" data-toggle="collapse"
                                data-target="#collapseheading5" aria-expanded="false" aria-controls="collapseheading5">
                                <span class="h4"> How to use the calendar ?</span>
                            </button>
                        </h5>
                    </div>
                    <div id="collapseheading5" class="collapse" aria-labelledby="heading5"
                        data-parent="#accordionExample275">
                        <div class="card-body">
                            <div class="d-flex justify-content-center">
                                <ol class="h5">
                                    <li class="p-1"><span class="h5">1.</span> You have to be logged in</li>
                                    <li class="p-1"><span class="h5">2.</span> Go to the calendar in the main menu
                                    </li>
                                    <li class="p-1"><span class="h5">3.</span> If you want to add one event click on add
                                        events
                                    </li>
                                    <li class="p-1"><span class="h5">4.</span> You can add an event just for you or a
                                        meeting for a team
                                    </li>
                                    <small>Note : Only if you are a coordinator you can add a meeting</small>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card z-depth-0 bordered">
                    <div class="card-header" id="heading6">
                        <h5 class="mb-0 text-center">
                            <button class="btn author-reference" type="button" data-toggle="collapse"
                                data-target="#collapseheading6" aria-expanded="false" aria-controls="collapseheading6">
                                <span class="h4"> How to create a new issue ?</span>
                            </button>
                        </h5>
                    </div>
                    <div id="collapseheading6" class="collapse" aria-labelledby="heading6"
                        data-parent="#accordionExample275">
                        <div class="card-body">
                            <div class="d-flex justify-content-center">
                                <ol class="h5">
                                    <li class="p-1"><span class="h5">1.</span> You have to be logged in and inside a
                                        project</li>
                                    <li class="p-1"><span class="h5">2.</span> First you need to have a issue list
                                    </li>
                                    <li class="p-1"><span class="h5">3.</span> After creating one you can add tasks to
                                        them
                                    </li>
                                    <li class="p-1"><span class="h5">4.</span> Lastly you can assign people and a due
                                        date
                                    </li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card z-depth-0 bordered" style="margin-bottom:0.95em;">
                    <div class=" card-header" id="heading7">
                        <h5 class="mb-0 text-center">
                            <button class="btn author-reference" type="button" data-toggle="collapse"
                                data-target="#collapseheading7" aria-expanded="false" aria-controls="collapseheading7">
                                <span class="h4"> How to leave a team ?</span>
                            </button>
                        </h5>
                    </div>
                    <div id="collapseheading7" class="collapse" aria-labelledby="heading7"
                        data-parent="#accordionExample275">
                        <div class="card-body">
                            <div class="d-flex justify-content-center">
                                <ol class="h5">
                                    <li class="p-1"><span class="h5">1.</span> Go to a project of yours</li>
                                    <li class="p-1"><span class="h5">2.</span> In the project menu click on Members
                                        inside the project overview
                                    </li>
                                    <li class="p-1"><span class="h5">3.</span> In the members you can remove yourself
                                        remove a member</li>
                                    <li class="p-1 text-center"> <small>Note: In case you are a coordinator you can also
                                            demote yourself
                                        </small>
                                    </li>
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>


            </div>


        </div>

    </div>
</div>
@endsection