<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>@yield('title')</title>
    @yield('script')
    <script src="https://js.pusher.com/6.0/pusher.min.js"></script>


    @yield('style')

    <script>
    // Fix for Firefox autofocus CSS bug
    // See: http://stackoverflow.com/questions/18943276/html-5-autofocus-messes-up-css-loading/18945951#18945951
    </script>

</head>

<body>
    <div class="page-wrapper h-100 is-collapsed">
        @if(empty($hide_navbar))
        @if (isset($user))
        @include('inc.navbar', ['user' => $user])
        @else
        @include('inc.navbar', ['user' => ''])
        @endif
        @endif

        @if($sidebar != 'none')
        @if (isset($project) && isset($user))
        @include('inc.sidebar_' . $sidebar, ['project' => $project, 'user' => $user])
        @elseif (isset($project))
        @include('inc.sidebar_' . $sidebar, ['project' => $project, 'user' => ''])
        @elseif (isset($user))
        @include('inc.sidebar_' . $sidebar, ['project' => '', 'user' => $user])
        @else
        @include('inc.sidebar_' . $sidebar, ['project' => '', 'user' => ''])
        @endif
        @endif
        <noscript>
            <span class="warning">Warning:&nbsp;</span><i>JavaScript</i> is currently disabled and is required to fully
            experience this website
        </noscript>

        <!--@include('inc.messages')-->

        <div class="{{Auth::check() ? 'main-container' :''}}">
            @yield('content')
            @if(empty($hide_footer))
            @include('inc.footer')
            @endif
        </div>
    </div>
</body>

</html>