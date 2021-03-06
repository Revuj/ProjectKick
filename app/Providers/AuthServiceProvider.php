<?php

namespace App\Providers;

use Illuminate\Support\Facades\Gate;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The policy mappings for the application.
     *
     * @var array
     */
    protected $policies = [
        // 'App\Card' => 'App\Policies\CardPolicy',
        //'App\Item' => 'App\Policies\ItemPolicy'
        'App\User' => 'App\Policies\UserPolicy',
        'App\Project' => 'App\Policies\ProjectPolicy',
        'App\EventMeeting' => 'App\Policies\MeetingPolicy'
    ];

    /**
     * Register any authentication / authorization services.
     *
     * @return void
     */
    public function boot()
    {
        $this->registerPolicies();
    }
}
