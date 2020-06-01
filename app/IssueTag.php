<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class IssueTag extends Model
{

    use Traits\HasCompositePrimaryKey;

    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'issue_tag';

    protected $fillable = ['issue_id', 'tag_id'];

    protected $primaryKey = ['issue_id', 'tag_id'];

    /**
     * @return
     */
    public function tag()
    {
        return $this->hasOne(Tag::class, 'tag_id');
    }

    /**
     * @return
     */
    public function issue()
    {
        return $this->hasOne(Issue::class, 'issue_id');
    }
}
