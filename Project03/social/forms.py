from django import forms

class InfoForm(forms.Form):
    employment=forms.CharField(label="employment",required=False,max_length=64)
    location=forms.CharField(label="location",required=False,max_length=128)
    interests=forms.CharField(label='add interests',max_length=64, required=False)
    birthday=forms.DateField(label='birthday',required=False,widget=forms.DateInput(attrs={'type':'date'}))