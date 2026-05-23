import { Component, OnInit, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';

type Weatherforecast = {
  date: string;
  summary: string;
  temperatureC: number;
  temperatureF: number;
};

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  template: `
    <h1>Hello, {{ title() }}</h1>
    <ul class="space-y-4">
      @for (item of data(); track item.date) {
        <li class="rounded-xl border border-gray-200 bg-white p-4 shadow-sm">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm text-gray-500">
                Date
              </p>
              <p class="text-lg font-semibold text-gray-900">
                {{ item.date }}
              </p>
            </div>

            <span
              class="rounded-full bg-blue-100 px-3 py-1 text-sm font-medium text-blue-700"
            >
          {{ item.summary }}
        </span>
          </div>

          <div class="mt-4 grid grid-cols-2 gap-4">
            <div class="rounded-lg bg-gray-50 p-3">
              <p class="text-sm text-gray-500">
                Celsius
              </p>
              <p class="text-xl font-bold text-gray-900">
                {{ item.temperatureC }}°C
              </p>
            </div>

            <div class="rounded-lg bg-gray-50 p-3">
              <p class="text-sm text-gray-500">
                Fahrenheit
              </p>
              <p class="text-xl font-bold text-gray-900">
                {{ item.temperatureF }}°F
              </p>
            </div>
          </div>
        </li>
      }
    </ul>
    <router-outlet />
  `,
  styles: [],
})
export class App implements OnInit {
  protected data = signal<Weatherforecast[]>([]);
  async ngOnInit(): Promise<void> {
    this.data.set(await fetch('http://localhost:5159/api/weatherforecast').then((res) => res.json()));
  }
  protected readonly title = signal('Web');
}
